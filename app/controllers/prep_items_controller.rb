class PrepItemsController < ApplicationController
  before_filter :set_menu_titles
  in_place_edit_for :prep_item, :title
  in_place_edit_for :prep_item, :description
  
  # GET /prep_items
  # GET /prep_items.xml
  def index
    @prep_items = @eg.prep_items

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
    extract_params_from_extjs
    @prep_item = PrepItem.new(params[:prep_item])
    @prep_item.project_ids = params[:prep_item][:project_ids]
    
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
    extract_params_from_extjs
    @prep_item = PrepItem.find(params[:id])
    
    respond_to do |format|
      if @prep_item.update_attributes(params[:prep_item])
        format.json { render :json => { :success => true, :prep_items => [@prep_item] } }
      else
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
      :paperwork => params[:paperwork],
      :title => params[:title],
      :description => params[:description],
      :project_ids => params[:project_ids],
      :prep_item_category_id => params[:prep_item_category_id],
      :event_group_id => @eg.id
    }
  end
end
