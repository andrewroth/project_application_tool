class ViewersController < ApplicationController
  include Permissions

  before_filter :set_subject
  before_filter :ensure_projects_coordinator, :except => [ :impersonate ]
  before_filter :ensure_eventgroup_coordinator, :only => [ :impersonate ]

  def impersonate
    unless session[:login_source] == 'impersonate'
      session[:viewer_before_impersonate] = @viewer.id
      session[:login_source_before_impersonate] = session[:login_source]
      session[:login_source] = 'impersonate'
    end
    session[:user_id] = params[:id]
    redirect_to :controller => 'main'
  end

  def merge
    if request.post?
      @recipient = Viewer.find params[:recipient_id]

      # copy all profiles over
      unless params[:skip_profiles] == '1'
        @profiles_copies = 0
        for p in @subject.profiles
          p.viewer_id = @recipient.id
          p.save!
          @profiles_copies += 1
        end
      end

      # copy gcx over
      if @recipient.guid.empty? && !@subject.guid.empty?
        @transfer_gcx = true
        @recipient.guid = @subject.guid
        @subject.guid = ''
      end
      # make subject inactive
      @subject.viewer_isActive = 0
      # and save
      @recipient.save!
      @subject.save!

      render 'merge_success'
    end
  end

  def merge_search
    name = params[:viewer]
    @people = Person.search_by_name name
    @viewers = Viewer.find_all_by_viewer_userID name
    @viewers += @people.collect {|p| p.viewers }.flatten
    @viewers.compact!

    # remove self
    @viewers.delete @subject
  end

  def deactive_action_for(params_key)
    (params[params_key.to_sym] || {}).each_pair do |key, value|
        key =~ /(.*)_(.*)/
        klass = $1
        id = $2
        yield klass.constantize.find(id)
    end
  end

  def deactivate
    if request.post?
      @subject = Viewer.find params[:id]
      deactive_action_for("reinstate") do |access|
        access.end_date = nil
        access.save!
      end
      deactive_action_for("revoke") do |access|
        access.end_date = Date.today
        access.save!
      end
    end

    @accesses = []
    @accesses << @subject.all_projects_coordinator if @subject.all_projects_coordinator.present?
    @accesses += @subject.all_eventgroup_coordinators + 
      Viewer.roles.collect{ |role| @subject.send("all_#{role.to_s.pluralize}") }.flatten
  end

  protected

  def set_subject
    @subject = Viewer.find params[:id]
  end
end
