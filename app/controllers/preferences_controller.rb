class PreferencesController < ApplicationController
  def index
    @page_title = "Preferences"
  end
  
  def update
    
    if @user.viewer.nil?
      flash[:notice] = %|Strangely, you are missing something needed to save your preferences.  
        Please email #{$tech_email_only} and let know you got this message.|
    else
      prefs = Preferences.find_by_viewer_id @user.id
      prefs.create(:viewer_id => @user.id) if !prefs

      prefs.update_attributes(params[:preferences])
      prefs.save!
      
      flash[:notice] = 'Preferences saved.'
    end
    
    redirect_to :action => :index
  end
end
