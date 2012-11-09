class EventGroupsController < AjaxTreeController
  include Permissions

  skip_before_filter :set_event_group, :except => [ :index, :update ]
  skip_before_filter :verify_event_group_chosen
  skip_before_filter :restrict_students
  skip_before_filter :verify_user, :only => [ :scope_by_slug, :custom_css ]
  
  prepend_before_filter :get_node
  before_filter :set_ministries_options, :only => [ :index, :create, :edit ]
  before_filter :ensure_eventgroup_coordinator_access_to_node, :only => [ :create, :update, :delete ]
  before_filter :set_title, :except => [ :scope, :set_as_scope ]

  # bug with caching when you edit, it caches the edit screen
  # then scope doesn't work
  before_filter :clear_cache#, :only => [ :create, :update, :destroy ]

  def nodes
  end

  def custom_css
    #headers["Content-Type"] = "text/css"
    @eg = EventGroup.find params[:id]
    render :file => 'event_groups/custom_css.erb', :content_type => 'text/css'
  end

  def views() [ 'scope' ] end

  def update
    delete_logo = params.delete :delete_logo

    super

    if delete_logo
      @node[:filename] = nil
      @node.save!
    end

    # clear session cache
    session[:logo_url] = nil
  end

  def scope
    @view = 'scope'
    @show_hidden = !params[:show_hidden].nil? && params[:show_hidden] # hide by default
    @columns = true

    unless read_fragment({:action => 'index'})
      if @show_hidden
        @nodes = EventGroup.find_all_by_parent_id(nil, :include => :projects)
      else
        @nodes = EventGroup.find_all_by_parent_id_and_hidden(nil, false, :include => :projects)
        @nodes.each do |n| n.filter_hidden = true end
      end
    end
    
    session[:logo_url] = nil

    index
  end

  def scope_by_slug
    @eg = EventGroup.find_by_slug(params[:slug])

    if @eg
      params[:id] = session[:event_group_id] = @eg.id
    else
      render :inline => "No event group with the key URL '#{params[:slug]}' found."
      return
    end

    if verify_user
      session[:start] = true
      set_as_scope
    end
  end

  def set_as_scope
    session[:event_group_id] = params[:id]
    session[:logo_img] = nil

    # update cookie
    if params[:remember]
      cookies[:event_group_id] = { 
        :value => params[:id],
        :expires => Time.now + 1.year
      }
    else
      cookies.delete :event_group_id
    end

    @eg = EventGroup.find(params[:id])
    if session[:start] && (form = @eg.forms.find_by_hidden(false))
      redirect_to :controller => :profiles, :action => :start, :form_id => form.id
    else
      redirect_to :controller => :main
    end
  end

  # GET /event_groups
  # GET /event_groups.xml
  def index
    @nodes = [] if read_fragment({:action => 'index'})

    respond_to do |format|
      format.js { 
        if params[:id] == 'roots'
          @nodes = EventGroup.roots
          @resources = []
        else
          eg = EventGroup.find(params[:id])
          @nodes = eg.children
          @resources = eg.event_group_resources
        end
        if params[:resources] == 'true'
          response_array = @nodes.collect{ |n| { :text => n.title, :id => n.id, :leaf => false, :allowDrag => false, :allowDrop => false, :expandable => !n.leaf? } }
          response_array += @resources.collect{ |egr| { :text => egr.title, :id => "#{eg.id}_#{egr.id}_#{egr.resource.id}", :leaf => true, :allowDrag => true, :allowDrop => false } }
          render :inline => response_array.to_json
        else
          render :inline => @nodes.collect{ |n| { :text => n.title, :id => n.id, :leaf => false, :expandable => !n.leaf? } }.to_json
        end
      }
      format.html {
        super
      }
    end
  end

  protected

    def node_table
      EventGroup
    end

    def set_title
      @page_title = "Manage Groups"
      @submenu_title = "Event Groups"
    end

    def clear_cache
      expire_fragment(:action => 'index')
    end

    def set_event_group
      @eg = EventGroup.find session[:event_group_id] if !EventGroup.find(:all).empty?
      session[:logo_url] = @eg.logo unless session[:logo_url]
    end

    def ensure_eventgroup_coordinator_access_to_node
      unless has_access_on_existing_node && has_access_on_new_node
        render :inline => 'no permission'
      end
    end

    def has_access_on_existing_node() params[:action] == 'create' || @viewer.is_eventgroup_coordinator?(@node) end

    def has_access_on_new_node
      if params[:event_group][:parent_id].empty?
        @viewer.is_projects_coordinator?
      else
        @viewer.is_eventgroup_coordinator?(EventGroup.find(params[:event_group][:parent_id]))
      end
    end
end
