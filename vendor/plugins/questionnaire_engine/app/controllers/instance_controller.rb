class InstanceController < BaseViewController

#  before_filter :get_current_page, :only => [:validate_page, :save_page, :submit]
  
  # this class has the save-related methods
  
  def save_page
    save_form
    render :template => "/instance/save_page", :layout => false
  end
  
  def submit
    save_form
    bad_pages = []
    @questionnaire.pages.each do |page|
      bad_pages << page.title unless page.validated?(questionnaire_instance) || page.hidden?
    end
    bad_pages.each {|title| @current_page.errors.add_to_base(title) }
    
    self.send(:validate_submit, @current_page) if (self.respond_to?(:validate_submit))
    
    unless @current_page.errors.empty?
      display_page
    else
      index = params[:next_page].to_i - 1
      @active_page = @questionnaire.pages[index]
      @position = params[:next_page].to_i
      
      # Try callback hook before rendering.    
      self.send(:after_submit) if (self.respond_to?(:after_submit))
      
      if request.xml_http_request?
        render(:template => "instance/default", :layout => false)
      else
        # pass the stuff given in extra_params in as well (this can hold for example the application id, 
        #   since a hidden form variable will be lost)
        redirect_to( { :action => :get_page, :next_page => @position }.merge(@pass_params || {}) )
      end
    end
  end
  
  def validate_page
    save_form
    @current_page.validate!(questionnaire_instance)
    
    display_page
  end
  
  def get_page
    if (request.post? || request.xml_http_request?) && (!params[:no_save] || params[:no_save]=="0")
      # Handle saving
      save_form
    end
    super
  end
  
  
    protected
    
    # by default we'll allow confidential questions to be rendered, 
    # since the students form will derive from this
    def see_confidential
      true
    end
    
    def save_form
      #Make sure we got a page back (defensive programming)
      if (@current_page)
        @elements = @current_page.elements
        # all the custom handler for each page in case it has custom fields
        if (self.respond_to?(@current_page.url_name))
          self.send(@current_page.url_name, true)
        end

        answers = get_answers
        #loop over questions
        for e in @elements
          e.save_answer(questionnaire_instance, params, answers)
        end
        
        self.send(:after_save_form) if (self.respond_to?(:after_save_form))
        
        # force a reload so that answer are reread from db
        questionnaire_instance.reload
      end
    end
end
