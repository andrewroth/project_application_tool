class ElementsController < ApplicationController
  include ControllerXML
  include ModelDefaultsForControllers
  include ElementsHelper

  before_filter :find_element, :except => [:index, :new, :create, :show_element_form]
  before_filter :find_page, :except => [:show_element_form, :set_is_required ]
  before_filter :set_default_text_area_max_length
  in_place_edit_for :element, :text   # set_element_text
  in_place_edit_for :element, :max_length   # set_element_max_length
  
  before_filter :set_flags
  
  TYPES_FOR_SELECT = [ ['', ''],
    ['Heading', 'Heading'],
    ['Instruction', 'Instruction'],
    ['Drop-down','Selectfield'],
    ['Text','Textfield'],
    ['Paragraph','Textarea'],
    ['Date/time', 'Datefield'],
    ['U.S. States', 'Statefield'],
    ['Radio buttons (choose one)', 'Radiofield'],
    ['Yes/No', 'YesNo'],
    ['Group', 'Group'],
    ['Checkbox Group (choose many)','Multicheckbox'],
    ['Checkbox', 'Checkboxfield']
  ]
    
  def index
    @elements = Element.find(:all)
  end
  
  def new
    @element = Element.new
  end
  
  def create
    create_with_params(params, request.post?)
  end
  
  def create_with_params(params, post)
    unless params[:element_type].empty?
      if params[:no_inheritance]
        @element = Element.new(params[:element])
        @element.type = params[:element_type]
      else
        @element = params[:element_type].constantize.new(params[:element])
      end

      @element.before_create_with_params(params) if @element.respond_to?(:before_create_with_params)

      if post and @element.save
        if params[:parent_id]
          @element.parent_id = params[:parent_id]
          @element.text = "New Element"
          @element.save!
        else
          PageElement.create(:element_id => @element.id, :page_id =>  @page.id)
          redirect_to edit_page_url(@questionnaire, @page) unless
            params[:no_redirect]
        end
      end

      @element.after_create_with_params(params) if @element.respond_to?(:after_create_with_params)
    else
      @element = Element.new
      @element.errors.add_to_base("You must choose an element type.")
      if params[:parent_id]
        render :update do |page|
          page.alert("Please choose what type of element you'd like to add")
        end
      else
        render :action => 'new'
      end
    end
    @element
  end
  
  def show
  end
  
  def edit
  end
  
  def change_type
    Element.connection.update("Update #{Element.table_name} SET type = '#{params[:type]}' WHERE id = #{@element.id}") if params[:type]
  end
  def update
    @element.attributes = params[:element]
    if @element.save
      respond_to do |format|
        format.html { redirect_to edit_page_url(@questionnaire, @page) }
        format.js { render :nothing => true }
      end
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    if request.delete?
      @element.destroy
    end
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.js 
    end
  end
  
  def copy
    @new = @element.deep_copy
    @new.save!
    PageElement.create(:page => @page, :element => @new) if @element.parent.nil?
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.js 
    end
  end
  
  def show_element_form
    if params[:class].nil? || params[:class].empty?
      render :action => 'blank'
    else
      @element = params[:class].constantize.new
    end
  end
  
  def reorder
    @element.elements.each do |element|
      element.position = params['group'].index(element.id.to_s) + 1
      raise element.errors.inspect unless element.save
    end
    render :nothing => true
  end
  
  def set_flag
    @element.send("is_#{params[:flag]}=", (params[:value] == "true" || params[:value] == "1") ? true : false)
    @element.save!
    render :inline => "success"
  end
  
  protected
    
    def set_flags() @flags = Flag.find(:all) end
    
    def find_element
      @element = Element.find(params[:id])
    end
    def find_page
      @page = Page.find(params[:page_id])
      @questionnaire = Questionnaire.find(params[:questionnaire_id])
    end
end
