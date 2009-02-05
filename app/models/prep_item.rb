class PrepItem < ActiveRecord::Base
  validates_presence_of :title, :description
  validates_uniqueness_of :title
  belongs_to :event_group
  belongs_to :project
  belongs_to :profile

  def self.find_prep_items
    find(:all, :order => "title")
  end
 
  def applies_to
    
    throw "PrepItems should exactly one of event_group_id, project_id or profile_id set" unless refs_set == 1
    
    if project
      :project
    elsif event_group
      :event_group
    else
      :profile
    end
  end
  
  def refs_set
    refs = 0
    refs += 1 if event_group
    refs += 1 if project
    refs += 1 if profile
    
    refs
  end
end