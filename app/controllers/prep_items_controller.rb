class PrepItemsController < ApplicationController
  before_filter :set_menu_titles
  in_place_edit_for :prep_item, :title
  in_place_edit_for :prep_item, :description
  
  before_filter :get_prev_modifieds
  after_filter :set_prev_modifieds
   
  # GET /prep_items
  # GET /prep_items.xml
  def index
    @prep_items = (@eg.prep_items + @eg.projects.collect {|p| p.prep_items}.flatten).uniq
    @prep_item=PrepItem.new
    @checkbox_projects = @eg.projects.find_all_by_hidden(false)
  end


  # POST /prep_items
  # POST /prep_items.xml
  def create
    @prep_item = PrepItem.new(params[:prep_item])
    @checkbox_projects = @eg.projects.find_all_by_hidden(false)
    
    respond_to do |format|
      if @prep_item.save
        flash[:notice] = 'PrepItem was successfully created.'
        session[:prev_modified_id] = session[:last_modified_id]
        @last_modified_id = @prep_item.id
        if @prev_modified_id != nil
          @prev_prep_item = PrepItem.find(@prev_modified_id)
        end
        check_prep_item_event_group_all
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
    @checkbox_projects = @eg.projects.find_all_by_hidden(false)
    
    respond_to do |format|
      if @prep_item.update_attributes(params[:prep_item])
        session[:prev_modified_id] = session[:last_modified_id]
        @last_modified_id = @prep_item.id
        if @prev_modified_id != nil
          @prev_prep_item = PrepItem.find(@prev_modified_id)
        end
        check_prep_item_event_group_all
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
    if params[:prep_item][:project_ids].to_a.empty? || params[(@prep_item.id.to_s + "_event_group_prep_item").to_sym]
      @prep_item.event_group_id = @eg.id
      @prep_item.projects.delete_all
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
