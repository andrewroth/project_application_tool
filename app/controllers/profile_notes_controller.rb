require 'permissions.rb'

class ProfileNotesController < ApplicationController
  # GET /profile_notes
  # GET /profile_notes.xml
  include Permissions
  
  before_filter :get_profile, :except =>[:create, :destroy]
  before_filter :ensure_profile_ownership_or_any_project_staff
  
  def index
    @profile_notes = @profile.profile_notes
    @profile_note = ProfileNote.new
  end


  # POST /profile_notes
  # POST /profile_notes.xml
  def create
    @profile_note = ProfileNote.new(params[:profile_note])
    @profile_note.creator_id = @user.viewer.id
    
    respond_to do |format|
      if @profile_note.save
        flash[:notice] = 'ProfileNote was successfully created.'
        
        format.html { redirect_to :action => 'index', :profile_id => @profile_note.profile.id }
        format.xml  { render :xml => @profile_note, :status => :created, :location => @profile_note }
        
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profile_note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /profile_notes/1
  # PUT /profile_notes/1.xml
  def update
    @profile_note = ProfileNote.find(params[:id])

    respond_to do |format|
      if @profile_note.update_attributes(params[:profile_note])
        flash[:notice] = 'ProfileNote was successfully updated.'
        format.html { redirect_to(index) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile_note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /profile_notes/1
  # DELETE /profile_notes/1.xml
  def destroy
    @profile_note = ProfileNote.find(params[:id])
    @profile_note.destroy

    respond_to do |format|
      format.js { render :rjs => 'destroy' }
      format.html { redirect_to(profile_notes_url) }
      format.xml  { head :ok }
    end
  end
end

def get_profile
    @profile = Profile.find params[:profile_id]
end