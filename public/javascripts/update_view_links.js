function update_view_links(controller, report, params, formats) {
    params_str = '';
    all_dropdowns_chosen = true;
    for (i = 0; i < params.length; i++) {
        try {
            type = $(report+'_'+params[i]).type;
            val = $F(report+'_'+params[i]);

            if (val != null) {
                params_str += '&' + params[i] + '=' + val;
            }
            
            if (type == 'select-one') {
                if (val == '' || val == ' ' || val == null) {
                    throw "no value";
                }
            }
        } catch(error) {
            all_dropdowns_chosen = false;
            break;
        }
    }
    for (i = 0; i < formats.length; i++) {
        if (all_dropdowns_chosen) {
            $(report+'_'+formats[i]).href = '/'+controller+'/' + report + '?' + params_str + '&format=' + formats[i];
            $(report+'_'+formats[i]).target = "_blank";
            $(report+'_'+formats[i]).show();
        } else {
            $(report+'_'+formats[i]).hide();
        }
    }
}
