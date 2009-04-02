
function Highlight(e){
	if(e.className == "required" || e.className == "reqfilled"){
		e.className = "reqactive";
	} else{
		e.className = "active";
	}
}

function UnHighlight(e){
	if(e.className == "reqactive"){
		e.className = e.value ? "reqfilled" : "required";
	} else if(e.className == "required"){
		e.className = e.value ? "reqfilled" : "required";
	} else
		e.className = "empty";
}

function UnHighlightAll(){
	for(var x = 0; x < document.forms.length; x++)
		for(var y = 0; y < document.forms[x].elements.length; y++){
			UnHighlight(document.forms[x].elements[y]);
	}
}

function init(){
	UnHighlightAll();
	//preloadImages();
	preload(2);
}
var dirty = false;
function set_dirty()
{
    dirty = true;
    $('form'+current_page).no_save.value = 0;
}
// Globals defining current and next page
var current_page = 1;
var next_page = 2;

function auto_save(page) {
    if(page == current_page && dirty) {
        save_page();
    }
}
function save_page() {
    var theform = $('form'+current_page);
    new Ajax.Request('/instance/save_page/'+current_page, {asynchronous:true, evalScripts:true, onLoading:function(request){Element.show('spinner2');}, onLoaded:function(request){Element.hide('spinner2')}, parameters:Form.serialize(theform)});
    dirty = false;
}

function validate_page() {
    var theform = $('form'+current_page);
    new Ajax.Updater('content'+current_page, '/instance/validate_page/'+current_page, {asynchronous:true, evalScripts:true, onComplete:function(request){Element.hide('validating');Element.show('content'+current_page);UnHighlightAll();}, parameters:Form.serialize(theform)});
    Element.hide('content'+current_page)
    Element.show('validating')
}

function submit_instance() {
    var theform = $('form'+current_page);
    theform.next_page.value = Math.min(page_count(), current_page + 1);
    theform.action = '/instance/submit/'+current_page
    theform.submit();
/*    new Ajax.Updater('content'+current_page, '/instance/submit/'+current_page, {asynchronous:true, evalScripts:true, onComplete:function(request){Element.hide('validating');Element.show('content'+current_page);UnHighlightAll();}, parameters:Form.serialize(theform)});
    Element.hide('content'+current_page)
    Element.show('validating') */
}

function post_form(next) {
	// use this to save the page and go to the next
	var theform = $('form'+current_page)
	theform.next_page.value = next;	// next page to display
	next_page = next;              // update global var
	// Change which page is highlighted
	switch_highlight(current_page, next)
	// only do the save if dirty is true
    if (dirty) {
        new Ajax.Request('/instance/get_page', {asynchronous:true, evalScripts:true, parameters:Form.serialize(theform)});
        dirty = false;
    }
    // If we already have div content, don't wait for the ajax
    if ($('content'+next).innerHTML && !$('content'+next).innerHTML.match("RAILS_ROOT")) {
        for(i=1; i<= page_count(); i++) {
            Element.hide('content'+i);
        }
        Element.hide('loading');
        Element.show('content'+next);
        UnHighlightAll();
    } else {
        theform.save_only.value = 'false'
        previous = current_page
    	new Ajax.Updater('content'+next, '/instance/get_page', {asynchronous:true, evalScripts:true, onComplete:function(request){Element.hide('loading');UnHighlightAll();}, onLoading:function(request){loading(previous,next)}, parameters:Form.serialize(theform)});
    }
    check_next_back(next)
    // Update what's current and what's next
    current_page = next
    next_page = (Number(next))+1
}

function loading(previous, next){
    Element.hide('content'+previous);
    Element.show('content'+next);
    if ($('content'+next).innerHTML == '') {
        Element.show('loading');
    }
}
function preload(next)
{   
    if (next <= page_count()) {
	    if ($('content'+next).innerHTML == '') {
//	        new Ajax.Updater('content'+next, '/instance/get_page?no_save=1&next_page='+next, {asynchronous:true, evalScripts:true, onComplete:function(request){preload(Number(next)+1);}});
	        new Ajax.Updater('content'+next, '/instance/get_page?no_save=1&next_page='+next, {asynchronous:true, evalScripts:true});
	    } else {
//	        preload(Number(next)+1);
	    }
    }
}
function switch_highlight(current, next)
{
    if(current <= page_count()) {
        $('title'+current).className = "menu";
        $('atitle'+current).className = "menu";
        $('num'+current).className = "menu";
        $('anum'+current).className = "menu";
    }
    $('title'+next).className = "menuactive";
    $('atitle'+next).className = "menuactive";
    $('num'+next).className = "menuactive";
    $('anum'+next).className = "menuactive";
}
function page_count()
{
     cells = $('page_numbers').getElementsByTagName("td")
     return cells.length - 1
}
function check_next_back(next)
{
    if (next == 1) {
        $('back').innerHTML = '';
    } else {
        $('back').innerHTML = '<a class="button" href="javascript: post_form(\''+(Number(next)-1)+'\')">&lt;&lt;Back</a>';
    }
    pages = page_count()
    if (next == pages) {
        $('next').innerHTML = '';
    } else {
        $('next').innerHTML = '<a class="button" href="javascript: post_form(\''+(Number(next)+1)+'\')">Next&gt;&gt;</a>';
        next = Number(next)+1;
        if ($('content'+next).innerHTML == '') {
	        //preload(next);
	    }
    }
}
function TrackCount(fieldObj,countFieldName,maxChars)
{
  var countField = eval("fieldObj.form."+countFieldName);
  var diff = maxChars - fieldObj.value.length;

  // Need to check & enforce limit here also in case user pastes data
  if (diff < 0)
  {
	fieldObj.value = fieldObj.value.substring(0,maxChars);
	diff = maxChars - fieldObj.value.length;
  }
  countField.value = diff;
}

function LimitText(fieldObj,maxChars)
{
  var result = true;
  if (fieldObj.value.length >= maxChars)
	result = false;
  
  if (window.event)
	window.event.returnValue = result;
  return result;
}