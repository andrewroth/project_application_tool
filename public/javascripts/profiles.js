function send_prep_item_data(id) {
  value = $("ppi_" + id).checked ? '1' : '0';
  $("loading").show();
  new Ajax.Request('/profile_prep_items/' + id, { 
    method: 'put', parameters: { 'profile_prep_item[submitted]': value, from_dashboard: true },
    onSuccess: function(transport, json) {
      $("loading").hide();
    }
  });
}
