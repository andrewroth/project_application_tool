require_dependency 'filter.rb'
require_dependency File.join(RAILS_ROOT,'vendor','plugins','questionnaire_engine','app','models','questionnaire')

class Questionnaire < ActiveRecord::Base
  include ModelXML
  has_many :questionnaire_pages
  has_many :pages, :through => :questionnaire_pages, :order => "position"
  
  include Filter
  Filter::setup self, :pages, :container => true
  
  def deep_copy
    copy = self.clone
    self.pages.each do |p|
      p_copy = p.deep_copy
      p_copy.save!
      QuestionnairePage.create(:questionnaire => copy, :page => p_copy)
    end
    copy
  end
  
  def xml_children
    pages 
  end
end
