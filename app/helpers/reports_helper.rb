module ReportsHelper
  def default_formats 
    [ 'html', 'excel (csv)' ]
  end

  def formats_js_array(formats = nil)
    ruby_array_to_js_array(formats || default_formats)
  end
  
  def new_window_js(url)
      "javascript: new_window(#{url})"
  end
  
  def report(text, action, params = {})
      formats = params[:formats] ||= default_formats
      
      form_content = ''
      if block_given?
          form_content = yield(action)
      else
          @init_js += "update_view_links('reports','#{action}', [ ], #{formats_js_array(formats)} );\n"
      end
      
      form_content += formats.collect { |f|
          link_to(f, '', :id => "#{action}_#{f}")
      }.join(' | ')
      
      append = @append; @append = ''
      
      %|#{ form_tag :action => action }
              #{ text }
              #{ form_content }
              #{ append }
            </form>
       |
       
  end
  
  def update_view_links_js(report, required_params, formats)
    required_params ||= []
    "update_view_links('reports','#{report}', [ " + required_params.collect{|rf| "'#{rf}'"}.join(',') + " ], " + 
              "#{formats_js_array(formats)} );"
  end
  
  # returns a block of html that will scope by updating the next scope level, 
  #    whether that be updating the links generate links (like
  #    'html' 'csv' etc with the dropdown value if it's the last scope, 
  #     or update the next level of scope
  def scope_report(report, params)
      
      include_blank = (params && params[:include_blank])
      include_all = (params && params[:include_all])
      
      scope, dropdown_choices, required_params, extra_form_content = 
          yield(include_blank, include_all)
      
      @init_js += "#{update_view_links_js(report, required_params, params[:formats])}\n" + 
                  "$('#{report}_spinner').hide();\n"
      
      %|for
              #{ select_tag("#{report}_#{scope}_id", options_for_select(dropdown_choices), 
                  :onChange => update_view_links_js(report, required_params, params[:formats]))
              }
              #{extra_form_content}
          #{image_tag("/images/spinner.gif", :id => "#{report}_spinner")}
      |
  end
  
  def project_specific_report(text, report, *params)
      params = params[0] if params # grab hash from array
      report(text, report, params) do
        project_specific_scope(report, params) do
          yield(report) if block_given?
        end
      end
  end
  
  def travel_segment_specific_report(text, report, *params)
      params = params[0] if params # grab hash from array
      
      report(text, report, params) do
          travel_segment_specific_scope(report, params) do
            yield(report) if block_given?
          end
      end
  end
  
  def project_specific_scope(report, params)
      scope_report(report, params) do |include_blank, include_all|
          include_pref1s_option = (params && params[:include_pref1s_option])
          hide_interns_option = (params && params[:hide_interns_option])
          
          dropdown_choices = []
          dropdown_choices << ['',''] if include_blank
          
          if params[:projects_list] == 'director'
              dropdown_choices += @project_director_projects.collect { 
                                      |p| [p.title, p.id]
                                }  
          else
              dropdown_choices += @project_with_full_view.collect { 
                                      |p| [p.title, p.id]
                                }
          end
          dropdown_choices << [ 'All', 'all' ] if include_all
          
          required_params = [ 'project_id' ]
          required_params << 'include_pref1s' if include_pref1s_option
          required_params << 'hide_interns' if hide_interns_option
          
          extra_form_content, extra_required_params = (yield(report) if block_given?) || ''
          required_params += extra_required_params.to_a
          
          include_pref1s_tag = %|
              <br />#{check_box_tag(report+"_include_pref1s", "true", false,
                  :onChange => update_view_links_js(report, required_params, params[:formats]))}
              Include in-progress applications with preference 1 as this project
          | 
          
          hide_interns_tag = %|
              <br />#{check_box_tag(report+"_hide_interns", "true", false,
                  :onChange => update_view_links_js(report, required_params, params[:formats]))}
              Hide interns from this report
          | 
           [ 'project',
            dropdown_choices,
            required_params,
            %|#{extra_form_content}
              #{include_pref1s_tag if include_pref1s_option}
              #{hide_interns_tag if hide_interns_option}
            |
          ]
      end
  end
  
  def travel_segment_specific_scope(report, params)
      scope_report(report, params) do |include_blank, include_all|
          include_profiles = (params && params[:include_profiles_option])
          
          dropdown_choices = []
          dropdown_choices << ['',''] if include_blank
          dropdown_choices += TravelSegment.current.find_all { |ts| ts.profiles.detect { |p| p.project && p.project.event_group_id == @eg.id } }.collect {
                                  |ts| [ ts.short_desc, ts.id]
                              }
          dropdown_choices << [ 'All', 'all' ] if include_all
          
          required_params = [ 'travel_segment_id' ]
          required_params << 'include_profiles' if include_profiles
          
          extra_form_content = (yield(report) if block_given?) || ''
          
          include_profiles_tag = %|
              <br />#{check_box_tag(report+"_include_profiles", "true", false,
                  :onChange => update_view_links_js(report, required_params, params[:formats]))}
              Include each person's entire profile, and highlight this travel segment
          |
  
          [ 'travel_segment',
            dropdown_choices,
            required_params,
            %|#{extra_form_content}
              #{include_profiles_tag if include_profiles}
             |
          ]
      end
  end
  
  def viewers_with_profile_for_project_choice(action, params = {})
    helper_for_project action, 'viewer', params.merge({:sub_action => 'viewers_with_profile_for_project'})
  end

  def cost_items_for_project(action, params = {})
    helper_for_project action, 'cost_item', params
  end

  def prep_items_for_project(action, params = {})
    helper_for_project action, 'prep_item', params
  end

  def helper_for_project(action, sub, params = {})
      params[:formats] ||= default_formats
      params[:include_blank] ||= true
      params[:include_all] ||= false
      params[:sub_action] ||= sub.pluralize + '_for_project'
      
      update_view_links_js = "update_view_links('reports','#{action}', [ 'project_id', '#{sub}_id' ], " + 
          "#{formats_js_array(params[:formats])});"

      select_item_id = "#{action}_#{sub}_id"
      div_select_item_id = "div_#{action}_#{sub}"

      observe_viewer_js = observe_field select_item_id, :function => update_view_links_js
      # grab the js only, without all the <script> CDATA stuff surrounding it, so we can put it in
      # the observe_project_js complete.  We need to do this since the viewer list is loaded later
      # so there's no observer set on it (or if there is one set before it's loaded, it won't work)
      observe_viewer_js_only = ''
      observe_viewer_js.scan(/CDATA\[\n(.*)\n\/\/\]\]/) do |w| observe_viewer_js_only = w[0] end
      
      observe_project_js = observe_field action+"_project_id",
           :url => {
              :controller => :reports,
              :action => params[:sub_action],
              :dom_id => select_item_id,
              :include_blank => params[:include_blank],
              :include_all => params[:include_all]
           },
          :update => div_select_item_id,
          :loading => "$('#{action}_spinner').show()",
          :complete => visual_effect(:highlight, "content") + "$('#{action}_spinner').hide(); " + observe_viewer_js_only + '; ' + update_view_links_js,
          :with =>  "'project_id='+escape($F('#{action}_project_id'))"
      
      [ %|#{observe_project_js}
          for <div id="#{div_select_item_id}" style="display:inline"></div> 
        |,
        [ "#{sub}_id" ]
      ]
  end

  def submit_js(format, form_id)
    "$('#{form_id}_format').value = '#{format}'; $('#{form_id}').submit();"
  end

  def html_pdf_submit_links(form_id)
    "#{link_to_function("html", submit_js("html", form_id))} | #{link_to_function("pdf", submit_js("pdf", form_id))}"
  end

  def html_excel_submit_links(form_id)
    "#{link_to_function("html", submit_js("html", form_id))} | #{link_to_function("excel (csv)", submit_js("csv", form_id))}"
  end

  def project_select(action, options = {})
    render :partial => 'report_form_project_select', :locals => { :action => action }.merge(options)
  end

  def project_observe_to_viewers(action, options = {})
    render :partial => 'report_form_project_observe_to_viewers', :locals => { :action => action, :options => options }
  end

  def project_observe_to_cost_items(action)
    render :partial => 'report_form_project_observe_to_cost_items', :locals => { :action => action }
  end

  def project_observe_to_prep_items(action)
    render :partial => 'report_form_project_observe_to_prep_items', :locals => { :action => action }
  end
end
