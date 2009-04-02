class ProjectsCoordinatorsController < ApplicationController
  SUPERADMIN_VIEWER_IDS = [ 1, 2939, 812 ] # first viewer, Andrew, Russ -- sorry for the magic ids, 
                                           # eventually we will find a better way :|

  before_filter :can_add_projects_coordinators
  before_filter :set_title

  def search
    @people = Person.search_by_name params[:name]
    respond_to do |format|
      format.html
    end
  end

  # GET /projects_coordinators
  # GET /projects_coordinators.xml
  def index
    @projects_coordinators = ProjectsCoordinator.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects_coordinators }
    end
  end

  # GET /projects_coordinators/1
  # GET /projects_coordinators/1.xml
  def show
    @projects_coordinator = ProjectsCoordinator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @projects_coordinator }
    end
  end

  # GET /projects_coordinators/new
  # GET /projects_coordinators/new.xml
  def new
    @projects_coordinator = ProjectsCoordinator.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @projects_coordinator }
    end
  end

  # POST /projects_coordinators
  # POST /projects_coordinators.xml
  def create
    @projects_coordinator = ProjectsCoordinator.find_or_create_by_viewer_id params[:projects_coordinator][:viewer_id]
    @projects_coordinator.update_attributes params[:projects_coordinator]

    respond_to do |format|
      if @projects_coordinator.save
        flash[:notice] = 'ProjectsCoordinator was successfully created.'
        format.html { redirect_to(projects_coordinators_url) }
        format.xml  { render :xml => @projects_coordinator, :status => :created, :location => @projects_coordinator }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @projects_coordinator.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects_coordinators/1
  # PUT /projects_coordinators/1.xml
  def update
    @projects_coordinator = ProjectsCoordinator.find(params[:id])

    respond_to do |format|
      if @projects_coordinator.update_attributes(params[:projects_coordinator])
        flash[:notice] = 'ProjectsCoordinator was successfully updated.'
        format.html { redirect_to(@projects_coordinator) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @projects_coordinator.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects_coordinators/1
  # DELETE /projects_coordinators/1.xml
  def destroy
    @projects_coordinator = ProjectsCoordinator.find(params[:id])
    @projects_coordinator.destroy

    respond_to do |format|
      format.html { redirect_to(projects_coordinators_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def can_add_projects_coordinators
    unless SUPERADMIN_VIEWER_IDS.include?(@viewer.id) || @viewer.is_projects_coordinator?
      flash[:notice] = "Sorry, you don't have permission to add projects coordinators."
      redirect_to :controller => :main, :action => :index
    end
  end

  def set_title() @page_title = 'Manage Groups'; @submenu_title = 'Projects Coordinators' end
end
