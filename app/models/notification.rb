require 'date_datetime_conversion'

class Notification < ActiveRecord::Base
  def begin_datetime() self[:begin_time].to_local_datetime end
  def end_datetime() self[:end_time].to_local_datetime end
    
  def premature?
    !ignore_begin && begin_time && DateTime.now < begin_datetime
  end

  def expired?
    !ignore_end && end_time && DateTime.now > end_datetime
  end

  def matches_controller?(controller)
    wildcards.include?(self.controller) || self.controller == controller
  end

  def matches_action?(action)
    wildcards.include?(self.action) || self.action == action
  end

  def wildcards() ['*', '', nil] end
end
