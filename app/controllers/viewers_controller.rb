class ViewersController < ApplicationController
  include Permissions

  before_filter :set_subject
  before_filter :ensure_eventgroup_coordinator

  def merge
    if request.post?
      @recipient = Viewer.find params[:recipient_id]

      # copy all profiles over
      @profiles_copies = 0
      for p in @subject.profiles
        p.viewer_id = @recipient.id
        p.save!
        @profiles_copies += 1
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

  protected

  def set_subject
    @subject = Viewer.find params[:id]
  end
end
