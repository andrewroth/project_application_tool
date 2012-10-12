function complete_prep_item(prep_item_id, profile_id) {
  set_complete_prep_item(true, prep_item_id, profile_id);
}

function uncomplete_prep_item(prep_item_id, profile_id) {
  set_complete_prep_item(false, prep_item_id, profile_id);
}

function set_complete_prep_item(value, prep_item_id, profile_id) {
  $("loading").show();
  new Ajax.Request('/profile_prep_items/set_completed', { 
    method: 'put', parameters: { prep_item_id: prep_item_id, profile_id: profile_id, completed: value },
    onSuccess: function(transport, json) {
      $("loading").hide();
    }
  });
}

document.observe('dom:loaded', function() {
          // second manual example : multicolor (and take all other default paramters)
          manualPB2 = new JS_BRAMUS.jsProgressBar(
                $('progress_bar'),
                progress,
                {

                  barImage  : Array(
                    '/images/bramus/percentImage_back4.png',
                    '/images/bramus/percentImage_back3.png',
                    '/images/bramus/percentImage_back2.png',
                    '/images/bramus/percentImage_back1.png'
                  ),

                  onTick : function(pbObj) {

                    switch(pbObj.getPercentage()) {

                      /*
                      case 98:
                        alert('Hey, we\'re at 98!');
                      break;

                      case 100:
                        alert('Progressbar full at 100% ... maybe do a redirect or sth like that here?');
                      break;
                      */

                    }

                    return true;
                  }
                }
              );
}, false);

