class ResourcesController < ApplicationController
  include Permissions

  before_filter :ensure_staff

  def create
    @resource = Resource.new(params[:resource])

    if @resource.save && params[:event_group_id].present?
      event_group = EventGroup.find params[:event_group_id]
      event_group.event_group_resources.create! :resource => @resource, :title => @resource.title, :description => @resource.description
    end

    respond_to do |format|
      format.json { 
        render :inline => { :success => @resource.errors.empty? }.to_json, :content_type => "text/html"
      }
    end
  end
end
