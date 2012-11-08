class EventGroupResourcesController < ApplicationController
  def index
    if params[:event_group_id]
      @event_group_resources = EventGroup.find(params[:event_group_id]).event_group_resources
    else
      @event_group_resources = []
    end

    respond_to do |format|
      format.json { render :json => { 
        :success => true,
        :message => "Loaded data",
        :data => @event_group_resources
      } }
    end
  end

  def create
    # TODO
    @event_group_resource = EventGroupResource.new(:title => params[:title], :description => params[:description])

    respond_to do |format|
      if @event_group_resource.save
        format.json { render :json => { :success => true, :event_group_resources => [@event_group_resource] } }
      end
    end
  end

  def update
    @event_group_resource = EventGroupResource.find(params[:id])

    respond_to do |format|
      if @event_group_resource.update_attributes(:title => params[:title], :description => params[:description])
        format.json { render :json => { :success => true, :event_group_resources => [@event_group_resource] } }
      end
    end
  end

  def destroy
    @event_group_resource = EventGroupResource.find(params[:id])
    @event_group_resource.destroy

    respond_to do |format|
      format.json { render :json => { :success => true } }
    end
  end
end
