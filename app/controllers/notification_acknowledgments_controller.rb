class NotificationAcknowledgmentsController < ApplicationController
  def create
    if @viewer.nil?
      render :inline => 'Need to login to remember hidden files'
      return
    end

    @notification = Notification.find params[:notification_id]
    @ack = NotificationAcknowledgment.new :viewer_id => @viewer.id,
             :notification_id => @notification.id
    @ack.save!

    render :inline => @notification.inspect
  end
end
