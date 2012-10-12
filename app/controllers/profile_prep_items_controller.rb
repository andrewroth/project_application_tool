class ProfilePrepItemsController < ApplicationController
  skip_before_filter :restrict_students
  before_filter :get_profile, :except => [ :update, :set_received, :set_checked_in, :set_completed ]
  
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

  def set_received
    @profile_prep_item = ProfilePrepItem.find_or_create_by_profile_id_and_prep_item_id(params[:profile_id], params[:prep_item_id])
    @profile_prep_item.update_attribute(:received_at, params[:received] == "true" ? DateTime.now : nil)
    respond_to do |format|
      format.js { render :inline => '' }
    end
  end

  def set_checkedin
    @profile_prep_item = ProfilePrepItem.find_or_create_by_profile_id_and_prep_item_id(params[:profile_id], params[:prep_item_id])
    @profile_prep_item.update_attribute(:checked_in, params[:checked_in] == "true")
    respond_to do |format|
      format.js { render :inline => '' }
    end
  end

  def set_completed
    @profile_prep_item = ProfilePrepItem.find_or_create_by_profile_id_and_prep_item_id(params[:profile_id], params[:prep_item_id])
    @profile_prep_item.update_attribute(:completed_at, params[:completed] == "true" ? DateTime.now : nil)
    @profile = @profile_prep_item.profile

    respond_to do |format|
      format.js
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
