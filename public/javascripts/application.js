function toggleSearch() {
  jQuery("#search").
    toggle().
    css("left", jQuery("#menu_search").offset().left - jQuery("#search").width() + jQuery("#menu_search").width()).
      find("input[type=text]").focus();
}

function after_ajax() {
  jQuery("[data-tip_html_selector]").each(function(i, el) {
    var tip = Ext.create('Ext.tip.ToolTip', {
      target: el.id,
      html: jQuery(jQuery(el).attr("data-tip_html_selector")).html(),
      anchor: 'left',
      anchorToTarget: true
    });
  });
}

jQuery(function() {
  after_ajax();
});

jQuery(document).ajaxSuccess(function() {
  after_ajax();
});
