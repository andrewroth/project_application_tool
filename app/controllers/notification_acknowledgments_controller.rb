class NotificationAcknowledgmentsController < ApplicationController
  def create
    if @user.nil?
      render :inline => 'Need to login to remember hidden files'
      return
    end

    @notification = Notification.find params[:notification_id]
    @ack = NotificationAcknowledgment.new :viewer_id => @user.id,
             :notification_id => @notification.id
    @ack.save!

    render :inline => @notification.inspect
  end
end
