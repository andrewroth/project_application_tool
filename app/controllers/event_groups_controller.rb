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
      format.js { render :inline => %|[{"text":"app","id":"src\/app","cls":"folder"},
        {"text":"ComponentManager.js","id":"src\/ComponentManager.js","leaf":true,"cls":"file"},
        {"text":"core","id":"src\/core","cls":"folder"},
        {"text":"XTemplateParser.js","id":"src\/XTemplateParser.js","leaf":true,"cls":"file"},
        {"text":"chart","id":"src\/chart","cls":"folder"},
        {"text":"diag","id":"src\/diag","cls":"folder"},
        {"text":"tab","id":"src\/tab","cls":"folder"},
        {"text":"FocusManager.js","id":"src\/FocusManager.js","leaf":true,"cls":"file"},
        {"text":"form","id":"src\/form","cls":"folder"},
        {"text":"Ajax.js","id":"src\/Ajax.js","leaf":true,"cls":"file"},
        {"text":"LoadMask.js","id":"src\/LoadMask.js","leaf":true,"cls":"file"},
        {"text":"ModelManager.js","id":"src\/ModelManager.js","leaf":true,"cls":"file"},
        {"text":"dom","id":"src\/dom","cls":"folder"},
        {"text":"layout","id":"src\/layout","cls":"folder"},
        {"text":"resizer","id":"src\/resizer","cls":"folder"},
        {"text":"Action.js","id":"src\/Action.js","leaf":true,"cls":"file"},
        {"text":"window","id":"src\/window","cls":"folder"},
        {"text":"PluginManager.js","id":"src\/PluginManager.js","leaf":true,"cls":"file"},{"text":"selection","id":"src\/selection","cls":"folder"},{"text":"ShadowPool.js","id":"src\/ShadowPool.js","leaf":true,"cls":"file"},{"text":"draw","id":"src\/draw","cls":"folder"},{"text":"picker","id":"src\/picker","cls":"folder"},{"text":"Shadow.js","id":"src\/Shadow.js","leaf":true,"cls":"file"},{"text":"slider","id":"src\/slider","cls":"folder"},{"text":"menu","id":"src\/menu","cls":"folder"},{"text":"Component.js","id":"src\/Component.js","leaf":true,"cls":"file"},{"text":"Template.js","id":"src\/Template.js","leaf":true,"cls":"file"},{"text":"Editor.js","id":"src\/Editor.js","leaf":true,"cls":"file"},{"text":"fx","id":"src\/fx","cls":"folder"},{"text":"tree","id":"src\/tree","cls":"folder"},{"text":"ElementLoader.js","id":"src\/ElementLoader.js","leaf":true,"cls":"file"},{"text":"AbstractPlugin.js","id":"src\/AbstractPlugin.js","leaf":true,"cls":"file"},{"text":"data","id":"src\/data","cls":"folder"},{"text":"ZIndexManager.js","id":"src\/ZIndexManager.js","leaf":true,"cls":"file"},{"text":"XTemplate.js","id":"src\/XTemplate.js","leaf":true,"cls":"file"},{"text":"Img.js","id":"src\/Img.js","leaf":true,"cls":"file"},{"text":"view","id":"src\/view","cls":"folder"},{"text":"ComponentLoader.js","id":"src\/ComponentLoader.js","leaf":true,"cls":"file"},{"text":"grid","id":"src\/grid","cls":"folder"},{"text":"util","id":"src\/util","cls":"folder"},{"text":"AbstractManager.js","id":"src\/AbstractManager.js","leaf":true,"cls":"file"},{"text":"tip","id":"src\/tip","cls":"folder"},{"text":"container","id":"src\/container","cls":"folder"},{"text":"ProgressBar.js","id":"src\/ProgressBar.js","leaf":true,"cls":"file"},{"text":"tail.js","id":"src\/tail.js","leaf":true,"cls":"file"},{"text":"toolbar","id":"src\/toolbar","cls":"folder"},{"text":"XTemplateCompiler.js","id":"src\/XTemplateCompiler.js","leaf":true,"cls":"file"},{"text":"ComponentQuery.js","id":"src\/ComponentQuery.js","leaf":true,"cls":"file"},{"text":"dd","id":"src\/dd","cls":"folder"},{"text":"button","id":"src\/button","cls":"folder"},{"text":"panel","id":"src\/panel","cls":"folder"},{"text":"state","id":"src\/state","cls":"folder"},{"text":"flash","id":"src\/flash","cls":"folder"},{"text":"Layer.js","id":"src\/Layer.js","leaf":true,"cls":"file"},{"text":"AbstractComponent.js","id":"src\/AbstractComponent.js","leaf":true,"cls":"file"},{"text":"direct","id":"src\/direct","cls":"folder"}]
        | }
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
