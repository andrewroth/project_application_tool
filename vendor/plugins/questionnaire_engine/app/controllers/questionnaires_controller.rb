class QuestionnairesController < ApplicationController
  include ControllerXML
  before_filter :find_questionnaire, :except => [:index, :new, :create, :import]
  in_place_edit_for :questionnaire, :title
  
  def index
    @questionnaires = "#{QE.prefix}questionnaire".camelize.constantize.find(:all)
  end
  
  def create
    create_with_title("New Application Type")
  end
  
  def create_with_title(title)
    @questionnaire = "#{QE.prefix}questionnaire".camelize.constantize.create(:title => title)
  end
    
  def show
  end
  
  def edit
  end
  
  def export
    setup_xml_file_header "#{@questionnaire.title}.xml"
    render :text => @questionnaire.to_xml_deep( 
      { :except => spt_attribute_exceptions } ), 
      :layout => false
  end
  
  def import
    import_from_xml
    
    redirect_to :controller => "questionnaires", :action => "index"
  end
  
  def update
    @questionnaire.attributes = params[:questionnaire]
    
    if request.put? and @questionnaire.save
      redirect_to questionnaire_url(@questionnaire)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    if request.delete?
      @questionnaire.destroy
    end
  end
  
  def copy
    @new = @questionnaire.deep_copy
    @new.save!
    @questionnaire = @new
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.js { render :action => :create}
    end
  end
  
  def reorder
    @questionnaire.questionnaire_pages.each do |page|
      page.position = params['questionnaire'].index(page.page_id.to_s) + 1
      page.save
    end
    render :nothing => true
  end
  
  protected
    def find_questionnaire
      @questionnaire = "#{QE.prefix}questionnaire".camelize.constantize.find(params[:id])
    end

end
