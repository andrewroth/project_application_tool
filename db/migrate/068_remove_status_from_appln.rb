class RemoveStatusFromAppln < ActiveRecord::Migration
  def self.up
    # first make sure each app still in the application process has an Applying profile
    # for it

    for app in Appln.find :all, :include => :profiles
      profile = app.profile # this will create an Applying profile if there is no profile for it

      puts "-- App #{app.id} status #{app[:status]} #{app[:status].class.name} by #{app.viewer.name}"

      if profile.class == Acceptance
        puts " Setting Acceptance confirmed for app #{app.id} by #{app.viewer.name if app.viewer}."
        profile.status = 'confirmed'
      elsif %w(started submitted completed unsubmitted).include? app[:status]
        puts " Matched status as in-progress... for app #{app.id} by #{app.viewer.name}"
        if profile.status != app[:status]
          puts " Making an Applying profile for app #{app.id} by #{app.viewer.name if app.viewer}."
          puts "  Setting its status to #{app[:status]}"
          profile.status = app[:status]
        end
        profile.project_id = app.preference1_id
      elsif %w(withdrawn declined).include? app[:status]
        if profile.class != Withdrawn
          puts " Making an Withdrawn profile for app #{app.id} by #{app.viewer.name if app.viewer}."
          profile[:type] = 'Withdrawn'
          profile.status = (app[:status] == 'withdrawn' ? 'self_withdrawn' : app[:status])
          puts "  Setting its status to #{profile.status}"
          profile.status_when_withdrawn = nil # don't know
          profile.class_when_withdrawn = nil # don't know
          profile.project_id = app.preference1_id
        end
      end

      # copy all the dates recorded date times
      puts " Copying completed_at, withdrawn_at, accepted_at, declined_at for app #{app.id} by #{app.viewer.name if app.viewer}."

      profile.completed_at = app[:completed_at]
      profile.withdrawn_at = app[:withdrawn_at] || app[:declined_at]
      profile.accepted_at = app[:accepted_at]

      profile.save!
    end

    remove_column :applns, :status
    remove_column :applns, :completed_at
    remove_column :applns, :withdrawn_at
    remove_column :applns, :accepted_at
    remove_column :applns, :declined_at
  end

  def self.down
    add_column :applns, :status, :string
    add_column :applns, :completed_at, :datetime
    add_column :applns, :withdrawn_at, :datetime
    add_column :applns, :accepted_at, :datetime
    add_column :applns, :declined_at, :datetime

    # sorry no looping through apps, no time/need for that
  end
end
