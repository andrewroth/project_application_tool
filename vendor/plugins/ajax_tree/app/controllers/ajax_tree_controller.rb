class AjaxTreeController < ApplicationController

  before_filter :get_node, :only => [ :destroy, :update, :edit, :expand, :collapse ]
  before_filter :set_tree_list, :only => [ :index, :new, :edit ]
  before_filter :try_to_get_view
  before_filter :set_singular_name
  before_filter :set_pluralized_name
  before_filter :set_type_options

  # GET /extender
  # GET /extender.xml
  def index
    @nodes ||= node_table.roots
    
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @extender.to_xml(:skip_types => true) }
    end
  end

  # GET /extender/1
  # GET /extender/1.xml
  def show
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @node.to_xml }
    end
  end

  # GET /extender/new
  def new
    @node = node_table.new
  end

  # GET /extender/1;edit
  def create_options
    render :layout => false, :template => 'ajax_tree/create_options'
  end

  # POST /extender
  # POST /extender.xml
  def create
    create_params = params[:"#{singular_name}"]
    parent_id = create_params[:parent_id] ? create_params.delete(:parent_id) : nil
    #type = create_params[:type].camelcase.constantize || node_table
    #@node = type.new(create_params)
    @node = EventGroup.new(create_params)
    @node.parent_id = parent_id
    @node.save!

    respond_to do |format|
      if @node.save
        flash[:notice] = "#{node_table} was successfully created."
        format.html { redirect_to send("#{pluralized_name}_path") }
        format.xml  { head :created, :location => node_url(@node) }
      else
        format.html { render({:action => "new"}, {}) }
        format.xml  { render :xml => @node.errors.to_xml }
      end
    end
  end

  # PUT /extender/1
  # PUT /extender/1.xml
  def update
    respond_to do |format|
      if @node.update_attributes(params[:node] || params[:"#{singular_name}"])
        flash[:notice] = 'node_table was successfully updated.'
        format.html { redirect_to send("#{pluralized_name}_url") }
        format.xml  { head :ok }
      else
        format.html { render({:action => "edit"}, {}) }
        format.xml  { render :xml => @node.errors.to_xml }
      end
    end
  end

  # DELETE /extender/1
  # DELETE /extender/1.xml
  def destroy
    @node.destroy

    respond_to do |format|
      format.html { redirect_to extender_url }
      format.xml  { head :ok }
    end
  end
  
  def expand
    @node.expanded = true
    @children = @node.children

    render :template => 'ajax_tree/expand_node', :layout => false
  end

  def collapse
    @node.expanded = false
    @children = @node.children

    render :template => 'ajax_tree/collapse_node', :layout => false
  end
  
  protected

    def set_tree_list
      @tree_list = node_table.to_list_options
    end

    def pluralized_name() node_table.name.underscore.pluralize end

    def singular_name() node_table.name.underscore.singularize end

    def get_node
      @node = node_table.find params[:id]
    end

    def try_to_get_view
      @view = params[:view] if respond_to?('views') && views.include?(params[:view])
    end

    def set_extending_instance_var
      eval "@#{singular_name} = @node"
    end

    def render(options = {}, local_assigns = {}, &block) #:nodoc:
      set_show_partial

      # copy @node to @{table_name} so that the extending model/controller 
      #  stuff still works.. we don't want to do this eval thing very often
      #  because eval is pretty slow and clunky.. so we'll make @node be used
      #  in this controller up to this point
      set_extending_instance_var

      if [:index, :scope].include? params[:action].to_sym
        set_expanded :roots => @nodes, :up_to_level => (@expanded_level ||= 3)
      end

      # call the ActionController::Base render to show the page
      super
    end

    def set_show_partial
      @show_partial = (@view ? "#{@view}_show" : singular_name)
    end

    # sets all params[:nodes] within params[:level] to expanded
    def set_expanded(params)
      if params[:level].nil?
        for node in params[:roots] || []
          set_expanded params.merge(:node => node, :level => 0)
        end
        return
      end

      params[:node].expanded = true
      return if params[:level] == params[:up_to_level]

      for child in params[:node].children
        set_expanded params.merge(:node => child, :level => params[:level] + 1)
      end
    end

    def extender_url
      self.send("#{pluralized_name}_url")
    end

    def set_singular_name() @singular_name = singular_name end
    def set_pluralized_name() @pluralized_name = pluralized_name end

    def set_type_options
      @type_options = node_table.types_options if node_table.respond_to?('types_options')
    end
end
