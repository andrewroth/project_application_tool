class FormsController < ApplicationController
  before_filter :get_form, :only => [ :show, :edit, :update, :destroy ]
  before_filter :set_title
  
  in_place_edit_for :form, :name

  def clone_form
    clonee = Form.find params[:id] # no need to scope by event group, that's a feature of cloning
    new_questionnaire = clonee.questionnaire.deep_copy
    @form = Form.create :name => clonee.name, :questionnaire_id => new_questionnaire.id, 
                        :event_group_id => @eg.id, :hidden => false

    new_questionnaire.title = @form.title_for_questionnaire
    new_questionnaire.save!

    @forms = @eg.forms :include => :questionnaire

    render :file => 'forms/reload_form_list.rjs', :use_full_path => true
  end

  # GET /forms
  # GET /forms.xml
  def index
    @forms = @eg.forms :include => :questionnaire
    @clone_form_options = Form.find(:all, :conditions => ["event_group_id != ?", @eg.id], 
    :include => :event_group).collect{ |form|
       [ form.to_s_with_eg_path, form.id ]
    }

    ensure_this_event_groups_emails
    @reference_emails = @eg.reference_emails
    @types = ReferenceEmailsController.types
  end

  # GET /forms/new
  def new
    @form = Form.new :event_group_id => @eg.id
  end

  # GET /forms/1;edit
  def edit
    @form = @eg.forms.find(params[:id])
    render :file => 'forms/show_edit_form.rjs', :use_full_path => true 
  end

  # POST /forms
  # POST /forms.xml
  def create
    @form = Form.new
    @form.event_group_id = @eg.id
    @form.name = params[:name]
    @form.hidden = params[:hidden].nil? ? 0 : 1

    if @form.save!
      @forms = @eg.forms :include => :questionnaire
      render :file => 'forms/reload_form_list.rjs', :use_full_path => true 
    else
      render :action => "new" 
    end

  end

  # PUT /forms/1
  # PUT /forms/1.xml
  def update
    questionnaire = @form.questionnaire
    questionnaire.title = params[:name]
    @form.name = params[:name]
    @form.hidden = params[:hidden].nil? ? 0 : 1
    if @form.save!
      questionnaire.save!
      @forms = @eg.forms :include => :questionnaire
      render :file => 'forms/reload_form_list.rjs', :use_full_path => true
    else
      flash[:notice] = 'Error saving form'
      redirect_to :action => "index"
    end
  end

  # DELETE /forms/1
  # DELETE /forms/1.xml
  def destroy
    @form.questionnaire.destroy
    
    applns = @form.applns
    
    applns.each { |a| a.destroy }
    
    @form.destroy

    @forms = @eg.forms :include => :questionnaire

    render :file => 'forms/reload_form_list.rjs', :use_full_path => true
    
  end

  protected

  def get_form
    @form = @eg.forms.find(params[:id])
  end

  def set_title
    @page_title = "Manage Forms"
  end

  def ensure_this_event_groups_emails
    @eg.ensure_emails_exist
  end

end
