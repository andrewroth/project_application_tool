
function get_menu_elem_class_name(elem) {
    return (elem.hover ? "hover_" : "") + 
        (elem.completed ? "completed_" : "incomplete_") + 
        (elem.active ? "menuactive" : "menuinactive");
}
function set_menu_elem_class_name(elem) {
    elem.className = get_menu_elem_class_name(elem);
}
function set_menu_param(elem, param, value) {
    elem[param] = value;
    set_menu_elem_class_name(elem);
}
function set_completed_b(elem, bool) { set_menu_param(elem, 'completed', bool); }
function set_completed(elem) { set_completed_b(elem, true); }
function set_incompleted(elem) { set_completed_b(elem, false); }
function set_active(elem) { set_menu_param(elem, 'active', true); }
function set_inactive(elem) { set_menu_param(elem, 'active', false); }

function hover_on(elem) {
    set_menu_param(elem, 'hover', true);
    window.status = 'Go to page ' + elem.index + ' (' + elem.page_name + ')';
}
function hover_off(elem) {
    set_menu_param(elem, 'hover', false);
    window.status='';
}

function init_elem(elem, index, page_name, completed, active) {
    elem.hover = false
    elem.index = index;
    elem.page_name = page_name;
    elem.completed = completed;
    elem.active = active;
    set_menu_elem_class_name(elem);
}

function Highlight(e) {
	if(e.className == "required" || e.className == "reqfilled"){
		e.className = "reqactive";
	} else{
		e.className = "active";
	}
}

function UnHighlight(e) {
	if(e.className == "reqactive"){
		e.className = e.value ? "reqfilled" : "required";
	} else if(e.className == "required"){
		e.className = e.value ? "reqfilled" : "required";
	} else
		e.className = "empty";
}

function UnHighlightAll() {
	for(var x = 0; x < document.forms.length; x++)
		for(var y = 0; y < document.forms[x].elements.length; y++){
			UnHighlight(document.forms[x].elements[y]);
	}
}

function setController(c) {
    controller = c
}

function init() {
	//preloadImages();
	preload(2);
	UnHighlightAll();
}

var dirty = [ false ];
for (i = 0; i < 50; i++) {
    dirty[i] = false;
}

var last_lost_connection_msg;
var last_lost_save_msg;
var hide_minutes = 10;
function seconds_from_now(d) {
    return (new Date().getTime() - d.getTime()) / 1000
}
function can_show_msg(last) {
    if (last != null && seconds_from_now(last) < hide_minutes * 60) {
        return false;
    }
    return true
}
function lost_connection_not_on_save() {
    if (!can_show_msg(last_lost_connection_msg)) { return; }
    last_lost_connection_msg = new Date();
//    alert('There was an error connecting to the server.  ' +
//        'Perhaps your internet is down or the server\'s internet is down.' + 
//        '\n\nThis message will not display for ' + hide_minutes + ' minutes.');
}
function lost_connection() {
    if (!can_show_msg(last_lost_save_msg)) { return; }
    last_lost_save_msg = new Date();
    alert('There was an error saving your latest work.  ' +
        'Perhaps the server is down or being restarted, or your internet is down.\n\n' + 
        'Your answers are autosaved *every minute* so it\'s only the last minute\'s answers that haven\'t been saved.  ' + 
        'Your unsaved answers are still stored in your web browser.  ' + 
        'You can continue your application on pages that have already loaded, ' +
        'but beware if you close your browser before the connection is re-established, you will lose new answers.' +
        '\n\nAll answers that have not been saved already ' +
        'will be tried to be saved every minute continually.  Check the message at the bottom of the page to see if they have been ' + 
        'successfully saved (it will say ' + save_success + ').  To ensure your answers are saved, please don\'t close your browser or submit until you check that message.' + 
        '\n\nThis message will not display for ' + hide_minutes + ' minutes.');
}

function set_dirty() {
    set_dirty_val(true, current_page)
}

var dirty_msg = 'there are answers that haven\'t been sent to the server';
var save_success = 'all answers have been received by the server';
function set_dirty_val(val, page) {
    dirty[page] = val;
    $('form'+current_page).no_save.value = 0;
    if (val) {
        $('dirty').innerHTML = "<i>" + dirty_msg + "</i>";
    }
    
    c = page_count();
    found_dirty = false;
    for (i = 0; i <= c; i++) {
        if (dirty[i]) {
            found_dirty = true;
            break;
        }
    }
    if (!found_dirty) {
        $('dirty').innerHTML = "<i>" + save_success + "</i>";
    }
}

var controller = 'appln'

// Globals defining current and next page
var current_page = 1;
var next_page = 2;

function auto_save(page) {
    save_all_dirty();
}

function save_all_dirty() {
    // todo: go through all pages, save all dirty ones
    c = page_count()
    for (i = 0; i <= c; i++) {
        if (dirty[i]) {
            save_page(i);
        }
    }
}

function save_page(page) {
    if (page == null || page == '') {
        page = current_page;
    }
    var theform = $('form'+page);
    new Ajax.Request("/" + controller + "/save_page/"+page, {
      asynchronous:true, evalScripts:true, 
      timeout: 30,
      onLoading:function(request){ Element.show('spinner2'); }, 
      onLoaded:function(request){ Element.hide('spinner2'); },
      onException: function(request){ 
        Element.hide('spinner2');
        lost_connection(); 
      },
      onFailure: function(request){
        Element.hide('spinner2'); 
        lost_connection(); 
      },
      onTimeout: function(request){
        Element.hide('spinner2'); 
        lost_connection(); 
      },
      onSuccess: function(request){ set_dirty_val(false, page); },
      parameters:Form.serialize(theform)});
}

function validate_page_dest(update, background, next) {
    var theform = $('form'+current_page);
    
    var errored = false;
    
    new Ajax.Updater(update, '/' + controller + '/validate_page/'+current_page, {
        asynchronous:true, 
        evalScripts:true, 
        onException: function(request){
            
            if (errored) return;  // for some ANNOYING reason it calls this method twice!!!!
            errored = true;
            
            if (next) {
                post_form(current_page);
            }
            
            lost_connection_not_on_save();
        },
        onLoaded:function(request) {
            if (!background) { 
                Element.hide('validating');
                Element.show(update);
                UnHighlightAll();
            }
        }, 
        parameters:Form.serialize(theform) + (next ? "&go_next_if_valid=true" : "") +
            (background ? "&script_only=true" : "")
    });

    if (!background) {
        Element.hide(update);
        Element.show('validating');
    } else {
        Element.hide(update);
    }
}

function validate_page() {
    validate_page_dest('content'+current_page, false, false)
}

/* Validates then goes on to the next page if no errors, 
  otherwise stays on current page and shows errors. */
function done_page() {
    validate_page_dest('content'+current_page, false, true);
}
function submit_instance() {
    var theform = $('form'+current_page);
    theform.next_page.value = current_page + 1;

    theform.action = '/' + controller + '/submit/'+current_page
    theform.submit();

/*
    new Ajax.Updater('content'+current_page, 
        '/appln/submit/'+current_page, {
            asynchronous:true, 
            evalScripts:true, 
            onComplete:function(request){
                Element.hide('validating');
                Element.show('content'+current_page);
                UnHighlightAll();
            }, 
         parameters:Form.serialize(theform)});
         */
    Element.hide('content'+current_page);
    Element.show('validating');
}

function post_form(next) {
    next = Number(next);
    
	// use this to save the page and go to the next
	var theform = $('form'+current_page)
	
	theform.next_page.value = next;	// next page to display
	next_page = next;              // update global var
    
	// Change which page is highlighted
	switch_highlight(current_page, next)

    // Only load the next page if the next page isn't already loaded.
    if ($('content'+next).innerHTML == "" && 
        !$('content'+next).innerHTML.match("RAILS_ROOT") &&
        !$('content'+next).innerHTML.match("<!--loading-->")) {
        
        // mark as loading so that an older load command doesn't replace
        // a loaded page (that may have answers typed into it)
        $('content'+next).innerHTML = "<!--loading-->";
        
        // load the next page
        theform.save_only.value = 'false';
    	new Ajax.Updater('content'+next, '/' + controller + 
    	   '/get_page', {
    	       asynchronous:true, 
    	       evalScripts:true, 
    	       onComplete: function(request) { 
    	           Element.hide('loading');
    	           UnHighlightAll();
    	       },
               onException: function(request){ 
                  lost_connection_not_on_save();
               },
    	       onLoading: function(request) {
    	           loading(previous,next)
    	       }, 
           parameters:Form.serialize(theform)});

        Element.hide('loading');
        UnHighlightAll();
    }
    
    // show actual content
    for (i=1; i<= page_count(); i++) {
        Element.hide('content'+i);
    }
    Element.show('content'+next);
    
    // save all the dirty pages
    save_all_dirty()

    // update completedness of page menu items for current page in 
    // an ajax request so that it will update in the background as
    // the next page is displayed
    validate_page_dest('update_completedness_last_pg', true, false)

	// update buttons
    check_next_back(next_page)

    // Update what's current and what's next
    previous = current_page
    current_page = next
    next_page = current_page+1

    // preload next page 
    preload(next_page);
}

function loading(previous, next){
    Element.hide('content'+previous);
    Element.show('content'+next);
    if ($('content'+next).innerHTML == '' 
        || $('content'+next).innerHTML == '<!--loading-->') {
        Element.show('loading');
    }
}

function preload(next) {   
    if (next <= page_count()) {
	    if ($('content'+next).innerHTML == '') {
            theform = $('form'+1)
            theform.save_only.value = 'false';
//	        new Ajax.Updater('content'+next, '/' + controller + '/get_page?no_save=1&next_page='+next, {asynchronous:true, evalScripts:true, onComplete:function(request){preload(Number(next)+1);}});
	        new Ajax.Updater('content'+next, '/' + controller + '/get_page?no_save=1&next_page='+next, 
	           {
	               asynchronous:true, 
                   onException: function(request){ 
                      lost_connection_not_on_save();
                   },
                   parameters:Form.serialize(theform),
	               evalScripts:true
	           });
	    } else {
//	        preload(Number(next)+1);
	    }
    }
}

function switch_highlight(current, next) { 
    if (current <= page_count()) {
        //set_inactive($('page_td' + current));
        set_inactive($('section_li' + current));
    }
    //set_active($('page_td' + next));
    set_active($('section_li' + next));
}

function page_count() {
    cells = $('page_list').getElementsByTagName('td')
    return cells.length - 1
}

function check_next_back(next) {
    
    /*
    if (Number(next) - 1 == 0) {
        $('back').hide();
    } else {
        $('back').show();
    }
    */
    $('back').hide();  // eeeh, no back button
    
    pages = page_count()
    if (next == pages) {
        $('next').hide();
    } else {
        $('next').show();
        next = Number(next)+1;
        if ($('content'+next).innerHTML == '') {
	        //preload(next);
	    }
    }
}

function TrackCount(fieldObj,countFieldName,maxChars) {
  var countField = eval("fieldObj.form."+countFieldName);
  var diff = maxChars - fieldObj.value.length;

  // Need to check & enforce limit here also in case user pastes data
  if (diff < 0) {
	fieldObj.value = fieldObj.value.substring(0,maxChars);
	diff = maxChars - fieldObj.value.length;
  }
  
  countField.value = diff;
}

function LimitText(fieldObj,maxChars) {
  var result = true;
  if (fieldObj.value.length >= maxChars)
	result = false;
  
  if (window.event)
	window.event.returnValue = result;
  return result;
}
