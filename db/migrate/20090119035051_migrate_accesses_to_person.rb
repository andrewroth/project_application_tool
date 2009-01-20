Person

class Person < CimHrdb
  has_many :viewers, :through => :access
end

class MigrateAccessesToPerson < ActiveRecord::Migration
  def self.up
    # migrate all user values
    ps = Person.find(:all, :include => :viewers)
    for p in ps
      p.update_attribute(:person_viewer_id, p.viewers.first.id) unless p.viewers.empty? || p.viewers.first.nil?
    end
  end

  def self.down
    remove_column Person.table_name, :person_viewer_id
  end

end
