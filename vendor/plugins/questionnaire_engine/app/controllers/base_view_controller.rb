class BaseViewController < ApplicationController
  include ModelDefaultsForControllers
  
  before_filter :set_instance
  before_filter :set_questionnaire, :except => [:no_access]
  before_filter :set_filter, :except => [:no_access]
  before_filter :get_pages, :except => [:no_access]
#  before_filter :get_current_page, :only => [:index, :get_page]
  before_filter :get_current_page, :only => [:index, :get_page, :validate_page, :save_page, :submit]
  before_filter :set_custom_folder
  before_filter :set_default_text_area_max_length
  
  helper_method :questionnaire_instance
  
  def set_custom_folder
    @custom_folder = "readonly" if params[:view] == 'print'
  end
  
  def index
    get_page
  end
  
  def save_page
    render :inline => ''
  end

  def get_page
    #check to see if save_only is set
    if (!params[:save_only] || params[:save_only] == "false")
      index = 0
      if params[:next_page]
        # we subtract 1 because the array index starts at 0
        index = params[:next_page].to_i - 1
      end
      @active_page = @pages[index]
      @position = index + 1
      display_page
    else 
      #if this is a save_only request, render nothing
      render :nothing => true
    end
  end
  
  protected
    def display_page
      @active_page ||= @current_page
      @active_page.filter = get_filter if !@active_page.nil?
      
      if @active_page.nil?
        # no pages to see?! that's crazy!
        render :inline => "<I>No pages to display</I>", :layout => false
        return
      end
      
      if (self.respond_to?(@active_page.url_name))
        self.send(@active_page.url_name)
      end
      
      @see_confidential = see_confidential
      
      use_layout = params[:layout].nil? ? !request.xml_http_request? : params[:layout]
      use_layout = false if params[:layout] == 'false'
      
      render(:template => "instance/default", :layout => use_layout)
    end
    
    def get_answers
      @answers = Hash.new
      questionnaire_instance.answers.each do |a| 
        @answers[a.question_id] = a
      end
      @answers
    end
    
    def questionnaire_instance
      # Replace this with whatever you use to attach answers to a person
      raise "You must overwrite this method for this engine to work!"
    end
    
    def get_questionnaire
      return false if 'redirected' == @instance
      unless @instance
        redirect_to :action => :no_access
        @instance = 'redirected'
        return false
      end
      return @instance.questionnaire if @instance.respond_to?('questionnaire')
      return @instance.class.questionnaire
    end
    
    def set_filter
      @questionnaire.filter = get_filter
    end
    
    def get_pages
      unless @questionnaire
        instance_str = begin @instance.id.to_s rescue '' end
        event_group_str = begin @instance.instance.form.event_group.title rescue '' end
        render(:inline => "Error: No questionnaire specified for this instance #{instance_str}", :layout => true)
        return
      end

      @pages ||= @questionnaire.pages
    end
    
    def get_current_page
      #get the current page with all the elements that are questions
      @position = params[:current_position] ? params[:current_position].to_i : 1
      @current_page = @pages[@position - 1]
      @current_page.filter = get_filter if !@current_page.nil?
    end
    
    def set_instance() 
      @instance ||= questionnaire_instance
      @questionnaire_instance ||= @instance
    end
    
    def set_questionnaire() @questionnaire ||= get_questionnaire end
    
    def get_filter() nil end # no filter by default    
end
