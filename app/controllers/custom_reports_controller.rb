require_dependency 'permissions'

class CustomReportsController < ApplicationController
  include Permissions

  before_filter :set_title
  before_filter :ensure_staff
  before_filter :set_show_projects, :only => [ :show, :render_report ]
  before_filter :ensure_project_access, :only => [ :render_report ]

  active_scaffold :report do |config|
    config.columns = [ :title, :include_accepted, :include_applying, :include_staff, :report_elements ]
    config.update.columns.exclude :position
    config.columns[:report_elements].associated_limit = 1000
  end

  def conditions_for_collection
    ['event_group_id = ?', @eg.id ]
  end

  def render_report
    @format = params[:format]
    @format = 'csv' if @format == 'excel(csv)'

    @report = Report.find params[:id], :include => :report_elements

    # filter out the confidential questions
    #logger.info 'AT FILTER'
    if @viewer.is_eventgroup_coordinator?(@eg)
      @report_elements = @report.report_elements
    else
      @report_elements = @report.report_elements.reject { |re|
        re.class == ReportElementQuestion && re.element && re.element.is_nested_confidential?
      }
    end

    # now get the answers
    #logger.info 'AT ANSWERS'
    answers = Answer.find_all_by_question_id @report_elements.reject{|re| re.class != ReportElementQuestion}.collect{ |re| 
      #logger.info 'AT ANSWERS collecting @report_elements, re.id='+re.id.to_s+' re[:element_id]='+re[:element_id].to_s
      e = re.element

      r = [ e.id ]
      if e.class == Multicheckbox
        r += e.elements.collect(&:id)
      end

      r
    }.flatten

    sort = true
    if sort
      answers.sort!{ |a1,a2| a1 <=> a2 }
      #quicksort(answers, 0, answers.length-1)
    end

    # loop through people, record results
    #logger.info 'AT PEOPLE'
    @results = []
    i = 0

    for_viewers_in_project(params[:project_id]) do |viewer, person, profile, appln|
      @results << render_row(sort, answers, viewer, person, profile, appln)
      i += 1
    end

    @results.sort! { |r1,r2|  if r1.length > 0 && r2.length > 0 then r1[0] <=> r2[0] else 0 end }

    if @format == 'csv'
      headers['Content-Type'] = "text/csv"
      headers['Content-Disposition'] = "attachment; filename=\"#{@report.title}.csv\""
      headers['Cache-Control'] = ''
    end

    render :layout => false
  end

  def before_create_save(record)
  end

  def after_create_save(record)
    if record.is_a?(Report)
      record[:event_group_id] = @eg.id
    elsif record.is_a?(ReportElement)
      record[:position] = if record.just_created? &&
                            session[:new_report_element_position].class == Hash &&
                            session[:new_report_element_position][record.uid] then
        
        posn = session[:new_report_element_position][record.uid].to_i
        # move everything up
        res = ReportElement.find_all_by_report_id record.report_id, :conditions => [ 'position >= ?', posn.to_i ]
        for re in res
          re.position += 1
          re.save!
        end

        session[:new_report_element_position].delete record.uid # keep session clean
        posn.to_i
      else
        res = ReportElement.find_all_by_report_id record.report_id
        record.position = res.collect(&:position).compact.inject(0) { |p, max_pos| p > max_pos ? p : max_pos }
      end
    end

    record.save
  end

  protected

  def set_show_projects
    @show_projects = (@viewer.is_eventgroup_coordinator?(@eg) ? @eg.projects : @viewer.current_projects_with_any_role(@eg))
  end

  def ensure_project_access
    unless @show_projects.collect(&:id).include?(params[:project_id].to_i)
      render(:text => "Sorry, no permission to view that project.")
    end
  end

  def render_row(sort, answers_cache, viewer, person, profile, appln)
    row = [ ]

    project = profile.project
    emerg = person.emerg if person

    for re in @report_elements
      if re.class == ReportElementCostItem
        ci = re.cost_item
        if ci.nil?
          row << "Couldn't find cost item #{re.element_id}"
          next
        end

        if ci.optional
          row << (ci.optins.detect{ |oi| oi.profile_id == profile.id }.nil? ? '' : 'Y')
        else
          row << 'Y'
        end

      elsif re.class == ReportElementQuestion
        e = re.element

        # fix 1402 - http://ccc.clockingit.com/tasks/edit/79620
        if e.nil?
          row << "Couldn't find element #{re.element_id}"
          next
        end

        q = e.traverse_to_questionnaire

        # find answer by question_id and instance_id
        row << if appln
                 instance = if q.name == 'Processor Form'
                              appln.processor_form
                            else
                              # try to find a reference questionnaire
                              ri = appln.reference_instances.detect { |ri|
                                ri.questionnaire == q
                              }

                              ri || appln # use appln if can't find anything else
                            end

                 e.get_verbose_answer(instance, :cache => answers_cache, :cache_sorted => sort, :use_cache_only => true).to_s
        else
        ''
        end

      elsif re.class == ReportElementModelMethod
        mm = re.report_model_method

        if mm.nil?
          row << 'nil modelmethod'
        else
          method_s = mm.method_s
          class_s = mm.report_model.model_s

          result = if valid_eval_str(method_s) && valid_eval_str(class_s)
                     class_o = eval(class_s)
                     res = if class_o then class_o.send(method_s) else "error: '#{class_s}' not defined" end
                     res = if res.nil? then '' else res end 
                   else
                     'not allowed'
                   end

          row << result.to_s
        end
      end
    end

    row
  end

  def valid_eval_str(s)
    s =~ /^([a-zA-Z0-9]|\.|_)+$/
  end

  def for_viewers_in_project(pids)
    pids = @eg.projects.collect &:id if pids == 'all'
    profiles = Profile.find_all_by_project_id pids, :include => [ :appln, { :viewer => :persons } ]

    for profile in profiles
      viewer = profile.viewer
      person = if viewer then viewer.person else nil end
      appln = if profile.appln then profile.appln else nil end

      next unless (profile.class == Acceptance && @report.include_accepted) ||
        (profile.class == Applying && @report.include_applying) || 
        (profile.class == StaffProfile && @report.include_staff) 

      yield viewer, person, profile, appln
    end
  end

  def set_title
    @submenu_title = "Custom Reports"
  end
end
