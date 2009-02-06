class EventgroupCoordinatorsController < ApplicationController
  SUPERADMIN_VIEWER_IDS = [ 1, 2939, 812 ] # first viewer, Andrew, Russ -- sorry for the magic ids, 
                                           # eventually we will find a better way :|

  before_filter :can_add_eventgroup_coordinators
  before_filter :set_eg2, :except => :index
  before_filter :set_title

  def search
    @people = Person.search_by_name params[:name]
    respond_to do |format|
      format.html
    end
  end

  def list
    @eventgroup_coordinators = @eg2.eventgroup_coordinators
  end

  # GET /eventgroup_coordinators
  # GET /eventgroup_coordinators.xml
  def index
    if params[:id]
      set_eg2
    end

    redirect_to :action => :list, :id => (@eg2 || @eg).id
  end

  # GET /eventgroup_coordinators/new
  # GET /eventgroup_coordinators/new.xml
  def new
    @eventgroup_coordinator = EventgroupCoordinator.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @eventgroup_coordinator }
    end
  end

  # POST /eventgroup_coordinators
  # POST /eventgroup_coordinators.xml
  def create
    @eventgroup_coordinator = EventgroupCoordinator.find_or_create_by_event_group_id_and_viewer_id @eg2.id, params[:eventgroup_coordinator][:viewer_id]

    respond_to do |format|
      if @eventgroup_coordinator.save
        flash[:notice] = 'EventgroupCoordinator was successfully created.'
        format.html { redirect_to :action => :list, :id => @eg2.id }
        format.xml  { render :xml => @eventgroup_coordinator, :status => :created, :location => @eventgroup_coordinator }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @eventgroup_coordinator.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /eventgroup_coordinators/1
  # PUT /eventgroup_coordinators/1.xml
  def update
    @eventgroup_coordinator = EventgroupCoordinator.find(params[:id])

    respond_to do |format|
      if @eventgroup_coordinator.update_attributes(params[:eventgroup_coordinator])
        flash[:notice] = 'EventgroupCoordinator was successfully updated.'
        format.html { redirect_to(@eventgroup_coordinator) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @eventgroup_coordinator.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /eventgroup_coordinators/1
  # DELETE /eventgroup_coordinators/1.xml
  def destroy
    @eventgroup_coordinator = EventgroupCoordinator.find(params[:id])
    @eventgroup_coordinator.destroy

    respond_to do |format|
      format.html { redirect_to(eventgroup_coordinators_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def can_add_eventgroup_coordinators
    unless SUPERADMIN_VIEWER_IDS.include?(@user.id)
      flash[:notice] = "Sorry, you don't have permission to add projects coordinators."
      redirect_to :controller => :main, :action => :index
    end
  end

  def set_eg2
    @eg2 = EventGroup.find params[:id]
  end

  def set_title 
    @page_title = "Manage Groups"
    if @eg2 == @eg
      @submenu_title = "Current Event Group's Coordinators"
    else
      @submenu_title = "Event Groups"
    end
  end
end
