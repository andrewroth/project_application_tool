#require File.join(RAILS_ROOT, 'app','controllers','application')
#require File.join(RAILS_ROOT, 'app','controllers','reference_emails_controller')

class AddAppWithdrawnNotifyEmailToAllEventGroups < ActiveRecord::Migration
  def self.up
    for eg in EventGroup.find(:all, :include => :reference_emails)
      eg.ensure_emails_exist
    end
  end

  def self.down
    ReferenceEmail.delete_all "email_type = 'app_withdrawn_notify'"
  end
end
