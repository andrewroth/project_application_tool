// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function toggleSearch() {
  jQuery("#search").
    toggle().
    css("left", jQuery("#menu_search").offset().left - jQuery("#search").width() + jQuery("#menu_search").width()).
      find("input[type=text]").focus();
}
