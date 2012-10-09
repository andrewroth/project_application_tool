class PrepItemCategoriesController < ApplicationController
  def index
    if request.post?
      # WHY IS A POST COMING HERE?  STUPID RAILS
      create
      return
    end
    @prep_item_categories = PrepItemCategory.all

    respond_to do |format|
      format.json { render :json => { 
        :success => true,
        :message => "Loaded data",
        :data => @prep_item_categories
      } }
    end
  end

  def create
    @prep_item_category = PrepItemCategory.new(:title => params[:title], :event_group_id => @eg.id)

    respond_to do |format|
      if @prep_item_category.save
        format.json { render :json => { :success => true, :prep_item_categories => [@prep_item_category] } }
      end
    end
  end

  def update
    @prep_item_category = PrepItemCategory.find(params[:id])

    respond_to do |format|
      if @prep_item_category.update_attributes(params[:prep_item_category])
        format.json { render :json => { :success => true, :prep_item_categories => [@prep_item_category] } }
      end
    end
  end

  def destroy
    @prep_item_category = PrepItemCategory.find(params[:id])
    @prep_item_category.destroy

    respond_to do |format|
      format.json { render :json => { :success => true } }
    end
  end
end
