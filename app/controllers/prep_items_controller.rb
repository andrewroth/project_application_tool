class PrepItemsController < ApplicationController
  before_filter :set_menu_titles
  in_place_edit_for :prep_item, :title
  in_place_edit_for :prep_item, :description
  
  # GET /prep_items
  # GET /prep_items.xml
  def index
    @prep_items = (@eg.prep_items + @eg.projects.collect {|p| p.prep_items}.flatten).uniq
    @prep_item = PrepItem.new

    respond_to do |format|
      format.json { render :json => {
        :success => true,
        :message => "Loaded data",
        :data => @prep_items
      } }
    end
  end

  # POST /prep_items
  # POST /prep_items.xml
  def create
    extract_params_from_extjs if request.xhr?
    @prep_item = PrepItem.new(params[:prep_item])
    
    respond_to do |format|
      if @prep_item.save
        format.json { render :json => { :success => true, :prep_items => [@prep_item] } }
      else
        format.json { render :json => { :success => false } }
      end
    end
  end

  # PUT /prep_items/1
  # PUT /prep_items/1.xml
  def update
    extract_params_from_extjs if request.xhr?
    @prep_item = PrepItem.find(params[:id])
    
    respond_to do |format|
      if @prep_item.update_attributes(params[:prep_item])
        #format.js { render :rjs => 'update' }
        format.html { redirect_to(prep_items_url) }
        format.xml  { head :ok }
        format.json { render :json => { :success => true, :prep_items => [@prep_item] } }
      else
        #format.js { render :rjs => 'update' }
        format.html { render :action => "edit" }
        format.xml  { render :xml => @prep_item.errors, :status => :unprocessable_entity }
        format.json { render :json => { :success => false } }
      end
    end
  end

  # DELETE /prep_items/1
  # DELETE /prep_items/1.xml
  def destroy
    @prep_item = PrepItem.find(params[:id])
    @prep_item.destroy

    respond_to do |format|
      format.js { render :rjs => 'destroy' }
      format.html { redirect_to(prep_items_url) }
      format.xml  { head :ok }
      format.json { render :json => { :success => true } }
    end
  end
  
  protected
  
  def set_menu_titles() @page_title = 'Manage Projects'; @submenu_title = 'todos' end
  
  def extract_params_from_extjs
    params[:prep_item] = {
      :deadline => params[:deadline],
      :deadline_optional => params[:deadline_optional],
      :individual => params[:individual],
      :title => params[:title],
      :description => params[:description],
      :project_ids => params[:projects_ids],
      :prep_item_category_id => params[:prep_item_category_id]
    }
  end
end
