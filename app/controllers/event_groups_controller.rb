class EventGroupsController < AjaxTreeController
  include Permissions

  skip_before_filter :verify_event_group_chosen
  skip_before_filter :set_event_group
  skip_before_filter :restrict_students
  
  before_filter :set_ministries_options, :only => [ :index, :create, :edit ]
  before_filter :ensure_projects_coordinator, :except => [ :scope, :set_as_scope ]
  before_filter :set_title, :except => [ :scope, :set_as_scope ]

  # bug with caching when you edit, it caches the edit screen
  # then scope doesn't work
  before_filter :clear_cache#, :only => [ :create, :update, :destroy ]

  def views() [ 'scope' ] end

  def scope
    @view = 'scope'
    @show_hidden = !params[:show_hidden].nil? && params[:show_hidden] && @user.is_projects_coordinator? # hide by default
    unless read_fragment({:action => 'index'})
      if @show_hidden
        @nodes = EventGroup.find_all_by_parent_id(nil, :include => :projects)
      else
        @nodes = EventGroup.find_all_by_parent_id_and_hidden(nil, false, :include => :projects)
        @nodes.each do |n| n.filter_hidden = true end
      end
    end
    index
  end

  def set_as_scope
    session[:event_group_id] = params[:id]

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
    end

    def set_ministries_options
      @ministries_options = [ [ 'Same as parent', nil ] ] + Ministry.to_list_options
    end

    def clear_cache
      expire_fragment(:action => 'index')
    end

end
