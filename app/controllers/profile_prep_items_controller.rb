class ProfilePrepItemsController < ApplicationController
  skip_before_filter :restrict_students
  before_filter :get_profile, :except => :update
  
  # GET /profile_prep_items
  # GET /profile_prep_items.xml
  def index
    for prep_item in @profile.all_prep_items
      @profile.profile_prep_items.find_or_create_by_prep_item_id(prep_item.id).save!
    end
    @profile_prep_items = @profile.all_profile_prep_items
  end

  # POST /profile_prep_items
  # POST /profile_prep_items.xml
  def create
    @profile_prep_item = ProfilePrepItem.new(params[:profile_prep_item])

    respond_to do |format|
      if @profile_prep_item.save
        flash[:notice] = 'ProfilePrepItem was successfully created.'
        format.html { redirect_to(@profile_prep_item) }
        format.xml  { render :xml => @profile_prep_item, :status => :created, :location => @profile_prep_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profile_prep_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /profile_prep_items/1
  # PUT /profile_prep_items/1.xml
  def update
    @profile_prep_item = ProfilePrepItem.find(params[:id])

    respond_to do |format|
      if @profile_prep_item.update_attributes(params[:profile_prep_item])
        flash[:notice] = 'ProfilePrepItem was successfully updated.'
        format.js { render :rjs => 'update' }
        format.html { redirect_to(@profile_prep_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @profile_prep_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /profile_prep_items/1
  # DELETE /profile_prep_items/1.xml
  def destroy
    @profile_prep_item = ProfilePrepItem.find(params[:id])
    @profile_prep_item.destroy

    respond_to do |format|
      format.html { redirect_to(profile_prep_items_url) }
      format.xml  { head :ok }
    end
  end
  protected
    def get_profile
      @profile = Profile.find params[:id]
    end
end
