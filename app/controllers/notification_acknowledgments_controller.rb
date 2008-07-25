class NotificationAcknowledgmentsController < ApplicationController
  def create
    @notification = Notification.find params[:notification_id]
    @ack = NotificationAcknowledgment.new :viewer_id => @user.id,
             :notification_id => @notification.id
    @ack.save!

    render :inline => @notification.inspect
  end
end
