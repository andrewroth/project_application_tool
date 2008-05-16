require  'formatting'

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include Formatting
  
  def new_item(title, controller, action = '')
    item_html = "<li "
    if (title == @page_title)
      item_html += " class=\"menuactive\""
    else
      item_html += " class=\"menuinactive\""
    end
    item_html += ">"
   
    controller ||= params[:controller]
    #item_html += link_to title, :controller => controller, :action => action
    item_html += "<a href='/#{controller}/#{action}'>#{title}</a>"
   
    item_html += "</li>"
   
    return item_html
  end
  
  def ruby_array_to_js_array(arr)
    "[ " + arr.collect{ |item| 
      "'#{ (block_given? ? yield(item) : item).to_s}'" }.join(', ') + 
    " ]"
  end
  
  def auto_complete_result2(entries, field, phrase = nil, hidden_prefix = nil)
    return unless entries
    hidden_prefix = "<span style='display:none;'>#{hidden_prefix}</span>"
    items = entries.map { |entry| content_tag("li style='border: 0px; padding: 0px; padding: 1px;'", 
               phrase ? hidden_prefix + highlight(entry.send(field), phrase) : 
               hidden_prefix + h(entry.send(field))) }
    content_tag("ul", items.uniq)
  end
  
  def can_not_edit?(element)
    return questionnaire_instance.frozen? && !@active_page.is_always_editable? &&
      !element.is_or_inherits_flag?('always_editable')
  end
  
  def sortable_table(id = nil)
    @sortable_tables_used = true
    @next_free_table_id = 1000 if @next_free_table_id.nil?
    table_id_str = "sortable_table" + (if id.nil?
        "#{@next_free_table_id}_#{Time.now.to_i}"
      else
        id
      end).to_s
    table = "<table id=\"#{table_id_str}\" class=\"datagrid\">"
    @sortable_tables_to_initialize = [] if @sortable_tables_to_initialize.nil?
    @sortable_tables_to_initialize << table_id_str
    @next_free_table_id += 1;
    
    table
  end
  
  def td_tag(params = {})
    @td_index += 1 if @td_index;
    r = "<td "
    r += params.inject('') {|s,p| k,v = p; s + "#{k} = \'#{v}' "}
    r += ">"
  end
  
  def sub_menu_item(title, controller, action, params = {})
    item_html = "<li "
    if (title == @submenu_title)
      item_html += " class=\"submenuactive\""
    else
      item_html += " class=\"submenuinactive\""
    end
    item_html += ">"
    
#    item_html += link_to_remote title, :url => params, 
#      :update => "content",
#	  :loading => "$('loading').show();",
#	  :loaded => "$('loading').hide();"
    # removed ajax version (above) since it was causing sorting to mess up and also doesn't get into browser history
    params_html = params.collect{ |kv| k,v = kv; "#{k}=#{v}" }.join("&")
    item_html += "<a href='/#{controller}/#{action}?#{params_html}'>#{title}</a>"
    # link_to title, params
    
    item_html += "</li>"
    
    return item_html
  end
  
  def absolute_width_css(v)
    "width: #{v}; max-width: #{v}; min-width: #{v}"
  end
  
  # expects either two params name, type, [default]
  # or a has with :name and :type
  def th(*params)
    if params[0].class == String
      name = params[0]
      type = params[1]
      default = params[2] == true
    else
      params = params[0]
      name = params[:name]
      type = params[:type]
      default = params[:default] == true
    end
    
    default_str = default ? ", mochi:default='true'" : ""
    
    params.delete name
    params.delete type
    params.delete default
    other_params = params.inject('') {|s,p| k,v = p; s + "#{k} = \'#{v}' "}
    @td_index += 1 if @td_index;
    
    "<TH mochi:format=\"#{type}\" #{default_str} #{other_params}>#{name}</TH>"
  end

  def render(*params)
    if params[0] && params[1].class == Hash && params[0] == :remote
      return "&nbsp;" if @pdf

      show_loading = params[1].delete(:show_loading)

      @next_free_remote_index ||= 0
      div_id = "remote_#{@next_free_remote_index}"

      ret = %|
<div id='#{div_id}'></div>

<script>
#{ remote_function :update => div_id, :url => params[1], 
     :loading => ("$('loading').show();" if show_loading), :complete => ("$('loading').hide();" if show_loading) }
</script>
       |
      
      @next_free_remote_index += 1

      ret
    else
      super
    end
  end 
  
  def in_place_editor_onComplete(id, url, options)
      cost_sums_url =
    javascript_tag %Q|
  
    function ajax_error(transport) {
      rawText = transport.responseText;
      alert(rawText);
    }
    
    new Ajax.InPlaceEditor( "#{id}", "#{url}", 
      {onComplete: function(t) { #{remote_function(options)}} });
    |
  end
  
  def all_zones_with_canada_us_first
    priorities = ['canada/eastern', 'canada/pacific', 'canada', 'america']
    infinity = 1.0/0
    
    TZInfo::Timezone.all.sort{ |a,b|
      score = {}
      ['a','b'].each do |tz|
        score[tz] = infinity
        priorities.each_with_index do |country, i|
          if eval(tz).name.downcase[country]
            score[tz] = i
            break
          end
        end
      end
      
      if score['a'] == score['b']
        a.name <=> b.name
      else
        score['a'] <=> score['b']
      end
    }
  end
  
  def format_currency(val)
    return nil.to_s if val.nil?
    "%0.2f" % val.to_f
  end
  
  def initialize_sortable_tables
    return "" if @sortable_tables_to_initialize.nil?

    %|
<script>
  var sortableTableLoadSpecific = function() {
#{(@sortable_tables_to_initialize).collect{ |id| "    initialize_sortable_table('#{id}');" }.join("\n")}
  };
  
  #{request.xml_http_request? ? 'sortableTableLoadSpecific();' : 'addLoadEvent(sortableTableLoadSpecific);' }

</script>
|

  end
  
  def menu(id_prefix)
		len = @pages.length
	 	ret = ""
	 	@pages.each_with_index do |this_page, i|
   		unless this_page.hidden
     		i2 = i+1
	     	ret += yield i2, id_prefix + i2.to_s, this_page
	     	@init_script += %| elem = $('#{id_prefix}#{i2}'); init_elem(elem, #{i2}, '#{this_page.title}', #{@validated_cache[i2].to_s.downcase},  #{this_page.url_name == @active_page.url_name.to_s.downcase}); |
	   	end
	 	end
	 	ret
	end
end

