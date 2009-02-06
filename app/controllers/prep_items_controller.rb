class PrepItemsController < ApplicationController
  before_filter :set_menu_titles
  in_place_edit_for :prep_item, :title
  in_place_edit_for :prep_item, :description
  
  before_filter :get_prev_modifieds
  after_filter :set_prev_modifieds
   
  # GET /prep_items
  # GET /prep_items.xml
  def index
    @prep_items = @eg.prep_items + @eg.projects.collect {|p| p.prep_items}.flatten
    @projects = @eg.projects.find_all_by_hidden(false).collect { |p| [ p.title, p.id ] }
    @prep_item=PrepItem.new
  end
  
  # GET /prep_items/new
  # GET /prep_items/new.xml
  def new
    @prep_item = PrepItem.new
    @projects = @eg.projects.find_all_by_hidden(false).collect { |p| [ p.title, p.id ] }
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @prep_item }
      #<!--  <%= link_to 'New Paperwork Item', new_prep_item_path %> -->
    end
  end

  # GET /prep_items/1/edit
  def edit
    @prep_item = PrepItem.find(params[:id])
    @projects = @eg.projects.find_all_by_hidden(false).collect { |p| [ p.title, p.id ] }
  end

  # POST /prep_items
  # POST /prep_items.xml
  def create
    @prep_item = PrepItem.new(params[:prep_item])
    @projects = @eg.projects.find_all_by_hidden(false).collect { |p| [ p.title, p.id ] }
    check_prep_item_event_group_all
    
    respond_to do |format|
      if @prep_item.save
        flash[:notice] = 'PrepItem was successfully created.'
        session[:prev_modified_id] = session[:last_modified_id]
        @last_modified_id = @prep_item.id
        if @prev_modified_id != nil
          @prev_prep_item = PrepItem.find(@prev_modified_id)
        end
        format.js { render :rjs => 'create' }
        format.html { redirect_to(prep_items_url) }
        format.xml  { render :xml => @prep_item, :status => :created, :location => @prep_item }
      else
        format.js { render :rjs => 'create' }
        format.html {redirect_to :action => "new" }
        format.xml  { render :xml => @prep_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /prep_items/1
  # PUT /prep_items/1.xml
  def update
    @prep_item = PrepItem.find(params[:id])
    @projects = @eg.projects.find_all_by_hidden(false).collect { |p| [ p.title, p.id ] }
    check_prep_item_event_group_all
    
    respond_to do |format|
      if @prep_item.update_attributes(params[:prep_item])
        session[:prev_modified_id] = session[:last_modified_id]
        @last_modified_id = @prep_item.id
        if @prev_modified_id != nil
          @prev_prep_item = PrepItem.find(@prev_modified_id)
        end

        flash[:notice] = 'PrepItem was successfully updated.'
        format.js { render :rjs => 'update' }
        format.html { redirect_to(prep_items_url) }
        format.xml  { head :ok }
      else
        format.js { render :rjs => 'update' }
        format.html { render :action => "edit" }
        format.xml  { render :xml => @prep_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /prep_items/1
  # DELETE /prep_items/1.xml
  def destroy
    @prep_item = PrepItem.find(params[:id])
    @prep_item.destroy

    respond_to do |format|
      session[:prev_modified_id] = session[:last_modified_id]
        @last_modified_id = nil
        if @prev_modified_id != nil
          @prev_prep_item = PrepItem.find(@prev_modified_id)
        end
      format.js { render :rjs => 'destroy' }
      format.html { redirect_to(prep_items_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def set_menu_titles() @page_title = 'Manage Projects'; @submenu_title = 'paperwork' end
  
  def check_prep_item_event_group_all
    if params[:prep_item][:project_id].empty?
      @prep_item.event_group = @eg
    else
      @prep_item.event_group = nil
    end
  end

  def get_prev_modifieds
    @prev_modified_id = session[:prev_modified_id]
  end
  
  def set_prev_modifieds
    session[:prev_modified_id] = @last_modified_id
  end
  
end
