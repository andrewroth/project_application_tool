class User < ActiveRecord::Base
  load_mappings

  has_one :access, :foreign_key => :viewer_id
  has_many :persons, :through => :access

  def person
    persons.first
  end

  def username=(val)
    # don't let usernames be set to viewer_userID
  end

  def password() '' end
  def password=(val) '' end

  def self.test1() 'test1' end
end
