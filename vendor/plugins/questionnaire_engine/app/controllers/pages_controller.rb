class PagesController < ApplicationController
  include ControllerXML
  before_filter :find_page, :except => [:index, :new, :create, :import, :export_all]
  before_filter :find_questionnaire
  before_filter :set_flags
  
  def create
    @page = Page.new
    @page.title = "New Page"
    @page.url_name = u(@page.title.downcase)
#    @page.created_by = current_person
#    @page.updated_by = current_person
    @page.save!
    QuestionnairePage.create(:questionnaire_id => @questionnaire.id, :page_id => @page.id)
  end
  
  def show
  end
  
  def edit
  end
  
  def hide
    @page.hidden = !@page.hidden
    @page.save
    render :nothing => true
  end
  
  def destroy
    if request.delete?
      @page.destroy
    end
  end
  
  def export
    setup_xml_file_header "#{@page.url_name}_page.xml"
    render :text => @page.to_xml_deep( { :except => spt_attribute_exceptions } ), 
      :layout => false
  end
  
  def import
    import_from_xml
    
    redirect_to :controller => "questionnaires", :action => "edit", :id => @questionnaire.id
  end
  
  def copy
    @new = @page.deep_copy
    @new.save!
    QuestionnairePage.create(:questionnaire => @questionnaire, :page => @new)
    @page = @new
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.js { render :action => :create}
    end
  end
  
  def set_page_title
    @page.title = params[:value]
    @page.url_name = u(params[:value].downcase)
#    @page.updated_by = current_person
    @page.save
    render :text => params[:value]
  end
  
  def reorder
    @page.page_elements.each do |element|
      indexes = params['page'] || params['group']
      element.position = indexes.index(element.element_id.to_s) + 1
      element.save!
    end
    render :nothing => true
  end
  
  def set_flag
    @page.send("is_#{params[:flag]}=", (params[:value] == "true" || params[:value] == "1") ? true : false)
    @page.save!
    render :inline => "success"
  end
  
  protected
    def find_page
      @page = Page.find(params[:id])
    end
    def find_questionnaire
      @questionnaire = Questionnaire.find(params[:questionnaire_id]) if params[:questionnaire_id]
    end
    # add underscores
    def u(str)
      str.strip.gsub(/[[:space:][:punct:]]+/, '_')
    end
    def set_flags
      @flags = Flag.find(:all)
    end
end
