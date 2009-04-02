/* goes up the dom tree until it finds the root html or an
 * element of tag tag (eg <div> element is a tag 'div')*/
function get_parent_by_tag(node, tag) {
  // accept current node as the tag itself
  if (node.tagName.toLowerCase() == tag.toLowerCase()) {
    return node;
  }

  curr = node;

  while (curr.parentNode != null) {
    curr = curr.parentNode;
    if (curr.tagName.toLowerCase() == tag.toLowerCase()) {
      return curr;
    }
  }
}

/* the function that does it all, will check all new records
   and empty all inputs if there are no non-hidden inputs that
   have a value */
function as_dd_clear_empty_new_records(e) {
  form = get_parent_by_tag(e, 'form');
  records = form.getElementsByClassName('association-record-new');

  for (r = 0; r < records.length; r++) {
    as_dd_clear_hidden_if_nothing_else(records[r]);
  }
}

function as_dd_row_has_nonhidden_value(e) {
  if (e == null) { return false; }
  tr = get_parent_by_tag(e, 'tr');

  vts = value_able_tags();
  for (t = 0; t < vts.length; t++) {
    tag = vts[t];

    inputs = tr.getElementsByTagName(tag);

    for (i = 0; i < inputs.length; i++) {
      input = inputs[i];

      if (input.className.search('hidden') == -1 && input.type != 'hidden' && input.value != '') {
        return true;
      }
    }
  }

  return false;
}

function as_dd_clear_hidden_if_nothing_else(e) {
  if (as_dd_row_has_nonhidden_value(e) == false) {
    as_dd_clear_all(e);
  }
}

function value_able_tags() {
  // no select, cause some selects start defaulted to true.. 
  // and there's always going to be inputs anyways

  return [ 'input' ];
}

function as_dd_clear_all(e) {
  tr = get_parent_by_tag(e, 'tr')

  vts = value_able_tags();
  for (t = 0; t < vts.length; t++) {
    tag = vts[t];

    inputs = tr.getElementsByTagName(tag);

    for (i = 0; i < inputs.length; i++) {
      inputs[i].value = '';
    }
  }
}

function as_dd_reorder_positions(tbody) {
  trs = tbody.getElementsByClassName('association-position');

  for (i = 0; i < trs.length; i++) {
    tr = trs[i];

    tr.value = i;
  }

}

function as_dd_reorder_setup(e) {
  tbody = get_parent_by_tag(e, 'tbody');
  id_base = tbody.id;

  trs = tbody.getElementsByClassName('association-record');

  // we don't actually care about the orders (because they
  // will be set in as_dd_reorder_positions), but we want
  // each tr to have an id ending with _### where ### is some
  // number, so that the dragdrop object works
  for (i = 0; i < trs.length; i++) {
    tr = trs[i];
    tr.id = id_base + '_' + i;
  }

  Sortable.create(tbody.id, { tag: 'tr', onUpdate: as_dd_reorder_positions } );

  as_dd_reorder_positions(tbody); 
}

