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

