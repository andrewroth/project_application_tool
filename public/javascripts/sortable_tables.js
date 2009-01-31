/*

On page load, the SortableManager:

- Finds the table by its id (sortable_table).
- Parses its thead for columns with a "mochi:format" attribute.
- Parses the data out of the tbody based upon information given in the
  "mochi:format" attribute, and clones the tr elements for later re-use.
- Clones the column header th elements for use as a template when drawing 
  sort arrow columns.
- Stores away a reference to the tbody, as it will be replaced on each sort.
- Performs the first sort.


On sort request:

- Sorts the data based on the given key and direction
- Creates a new tbody from the rows in the new ordering
- Replaces the column header th elements with clickable versions, adding an
   indicator (&uarr; or &darr;) to the most recently sorted column.

*/

SortableManager = function () {
    this.thead = null;
    this.tbody = null;
    this.columns = [];
    this.rows = [];
    this.sortState = {};
    this.sortkey = 0;
    this.default_sort_column = 0;
};

mouseOverFunc = function () {
    addElementClass(this, "over");
};

mouseOutFunc = function () {
    removeElementClass(this, "over");
};

ignoreEvent = function (ev) {
    if (ev && ev.preventDefault) {
        ev.preventDefault();
        ev.stopPropagation();
    } else if (typeof(event) != 'undefined') {
        event.cancelBubble = false;
        event.returnValue = false;
    }
};

function loadAllSortableTables() {
  tables = document.getElementsByTagName("table");
  for (var i = 0; i < tables.length; i++) {
    if (tables[i].className == 'datagrid') {
      initialize_sortable_table(tables[i].id);
    }
  }
}

update(SortableManager.prototype, {

    "initWithTable": function (table) {
        /***

            Initialize the SortableManager with a table object
        
        ***/
        // Ensure that it's a DOM element
        table = getElement(table);

        // Find the thead, make sure it's not been initialized already
        if (table == null || table.getAttribute('initialized')) {
            return;
        }
	table.setAttribute('initialized', true);

        this.thead = table.getElementsByTagName('thead')[0];
        // get the mochi:format key and contents for each column header
        var cols = this.thead.getElementsByTagName('th');
        for (var i = 0; i < cols.length; i++) {
            var node = cols[i];
            var attr = null;
            try {
                attr = node.getAttribute("mochi:format");
            } catch (err) {
                // pass
            }
            var is_default = false;
            try {
                is_default = node.getAttribute("mochi:default");
            } catch (err) {
                // pass
            }
            var default_direction = 'ascending';
            try {
                default_direction = node.getAttribute("mochi:default_direction");
            } catch (err) {
                // pass
            }
            var o = node.childNodes;
            this.columns.push({
                "format": attr,
                "is_default": is_default,
                "default_direction": default_direction,
                "element": node,
                "proto": node.cloneNode(true)
            });
        }
        // scrape the tbody for data
        this.tbody = table.getElementsByTagName('tbody')[0];
        // every row
        var rows = this.tbody.getElementsByTagName('tr');
        for (var i = 0; i < rows.length; i++) {
            // every cell
            var row = rows[i];
            var cols = row.getElementsByTagName('td');
            var rowData = [];
            for (var j = 0; j < cols.length; j++) {
                // scrape the text and build the appropriate object out of it
                var cell = cols[j];
                var obj = scrapeText(cell);
                if (this.columns[j] == null) {
                    continue;
                }
                switch (this.columns[j].format) {
                    case 'date':
                    case 'isodate':
                        obj = isoDate(obj);
                        break;
                    case 'str':
                        break;
                    case 'lcase_str':
                    case 'istr':
                        obj = obj.toLowerCase();
                        break;
                    case 'integer':
                    case 'float':
                    case 'int':
                    case 'currency':
			try {
        
				val = obj.replace(/\$?(\-?\d+\.?\d*)/,"$1");
				if (val.length > 0) {
					obj = Number(val.gsub(',',''));
				} else {
					obj = 0;
				}

				break;
			} catch (err) {
				obj = 0;
			}

                    case 'dropdown':
                        try {
                            select = cell.getElementsByTagName('select')[0]; // use the first select found
                            obj = select[select.selectedIndex].text;
                        } catch  (err) {
                            obj = '';
                        }
                        break;
                    case 'input':
                        try {
                            input = cell.getElementsByTagName('input')[0]; // use the input found
                            obj = input.value;
                        } catch  (err) {
                            obj = '';
                        }
                        break;

                    default:
                        break;
                }
                // check for this column being the default sort column
                if (this.columns[j].is_default) {
		    this.default_sort_column = j
                    this.sortkey = j;
                }
                
                // make empty objects null so they are placed after ones that actually have a value
                if (!/\S/.test(obj.toString())) {
                    obj = null;
                }
                
                rowData.push(obj);
            }
            // stow away a reference to the TR and save it
            rowData.row = row.cloneNode(true);
            this.rows.push(rowData);

        }
        
        // this is really annoying, it seems IE loses cdata tags after drawSortedRows
        script_txt = [];
        scripts = this.tbody.getElementsByTagName('script');
        for (i = 0; i < scripts.length; i++) {
            script_txt.push(scripts[i].text);
        }

        select_values = {};
        selects = this.tbody.getElementsByTagName('select');
        for (i = 0; i < selects.length; i++) {
            select_values[selects[i].id] = selects[i].value;
        }
        
        // do initial sort on first column
	forward = this.columns[this.default_sort_column].default_direction != 'descending'
        this.drawSortedRows(this.sortkey, forward, false);
        
        // it seems that the we have to manually set which items are selected, they get reset to the first one
        // in the list
        selects = this.tbody.getElementsByTagName('select');
        for (i = 0; i < selects.length; i++) {
            selects[i].value = select_values[selects[i].id];
        }
        
        // it seems that the scripts have to be rerun, element monitors won't register changes otherwise
        for (i = 0; i < script_txt.length; i++) {
            eval(script_txt[i])
        }
    },

    "onSortClick": function (name) {
        /***

            Return a sort function for click events

        ***/
        return method(this, function () {
            var order = this.sortState[name];
            if (order == null) {
                order = true;
            } else if (name == this.sortkey) {
                order = !order;
            }
            this.drawSortedRows(name, order, true);
        });
    },

    "drawSortedRows": function (key, forward, clicked) {
        /***

            Draw the new sorted table body, and modify the column headers
            if appropriate

        ***/
        this.sortkey = key;
        // sort based on the state given (forward or reverse)
        var cmp = (forward ? keyComparator : reverseKeyComparator);
        this.rows.sort(cmp(key));
        // save it so we can flip next time
        this.sortState[key] = forward;
        // get every "row" element from this.rows and make a new tbody
        var newBody = TBODY(null, map(itemgetter("row"), this.rows));
        // swap in the new tbody
        this.tbody = swapDOM(this.tbody, newBody);

        for (var i = 0; i < this.columns.length; i++) {
            var col = this.columns[i];
            var node = col.proto.cloneNode(true);
            // remove the existing events to minimize IE leaks
            col.element.onclick = null;
            col.element.onmousedown = null;
            col.element.onmouseover = null;
            col.element.onmouseout = null;
            // set new events for the new node
            node.onclick = this.onSortClick(i);
            node.onmousedown = ignoreEvent;
            node.onmouseover = mouseOverFunc;
            node.onmouseout = mouseOutFunc;

            // if this is the sorted column
            if (key == i) {
                // \u2193 is down arrow, \u2191 is up arrow
                // forward sorts mean the rows get bigger going down
                var arrow = (forward ? "\u2193" : "\u2191");
                // add the character to the column header
                
                node.appendChild(SPAN(null, arrow));
                if (clicked) {
                    node.onmouseover();
                }
            }
 
            // swap in the new th
            col.element = swapDOM(col.element, node);
        }
    }
});

sortableManagers = {};

var loadFunction = function () {
    initialize_sortable_table('sortable_table');
    
    // load all tables
    found = true;
    for (i = 2; found; i++) {
        name = 'sortable_table' + i;
        if ($(name) == null) {
            found = false;
        } else {
            initialize(name);
        }
    }
};

function initialize_sortable_table(name) {
  sortableManagers[name] = new SortableManager();
  sortableManagers[name].initWithTable(name);  
}

addLoadEvent(loadFunction);

// rewrite the view-source links
addLoadEvent(function () {
    var elems = getElementsByTagAndClassName("A", "view-source");
    var page = "sortable_tables/";
    for (var i = 0; i < elems.length; i++) {
        var elem = elems[i];
        var href = elem.href.split(/\//).pop();
        elem.target = "_blank";
        elem.href = "../view-source/view-source.html#" + page + href;
    }
});
