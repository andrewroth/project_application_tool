class EventGroupsController < AjaxTreeController
  include Permissions

  skip_before_filter :set_event_group, :except => [ :index, :update ]
  skip_before_filter :verify_event_group_chosen
  skip_before_filter :restrict_students
  
  prepend_before_filter :get_node
  before_filter :set_ministries_options, :only => [ :index, :create, :edit ]
  before_filter :ensure_eventgroup_coordinator_access_to_node, :only => [ :create, :update, :delete ]
  before_filter :set_title, :except => [ :scope, :set_as_scope ]

  # bug with caching when you edit, it caches the edit screen
  # then scope doesn't work
  before_filter :clear_cache#, :only => [ :create, :update, :destroy ]

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

    redirect_to :controller => :main
  end

  # GET /event_groups
  # GET /event_groups.xml
  def index
    @nodes = [] if read_fragment({:action => 'index'})
    super
  end

  protected

    def node_table
      EventGroup
    end

    def set_title
      @page_title = "Manage Groups"
      @submenu_title = "Event Groups"
    end

    def set_ministries_options
      @ministries_options = [ [ 'Same as parent', nil ] ] + Ministry.to_list_options
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
