function set_all_hrefs_for_form(form_id, value) {
  hrefs = $$("#"+form_id+" a")
  for (i = 0; i < hrefs.length; i++) {
    href = hrefs[i];
    if (value) {
      href.show();
    } else {
      href.hide();
    }
  }
}

function update_hrefs_visibility(form_id) {
  selects = $$("#"+form_id+" select")
  for (i = 0; i < selects.length; i++) {
    select = selects[i];
    if (select.value == "") {
      set_all_hrefs_for_form(form_id, false);
      return;
    }
  }
  set_all_hrefs_for_form(form_id, true);
}

function observe_form_update_submit(form_id) {
  new Form.EventObserver(form_id, function(element, value) {
    update_hrefs_visibility(form_id);
  })
}

Element.addMethods({
  setVisibility: function(element, visible) {
    element = $(element);
    visible ? element.show() : element.hide();
  }
});

function toggle_manual_donations_type() {
  $('manual_donations_type_span').setVisibility($('manual_donations_project_id').value != "");
  toggle_manual_donations_status();
}

function toggle_manual_donations_status() {
  $('manual_donations_status_span').setVisibility($('manual_donations_project_id').value != "" && 
      $('manual_donations_type').value == "USDMANUAL");
}
