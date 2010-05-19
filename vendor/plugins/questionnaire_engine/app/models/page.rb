load 'filter.rb'

class Page < ActiveRecord::Base
  set_table_name "#{QE.prefix}pages"
  include CustomPages
  include ModelXML
  include Filter
  
  has_many :questionnaires, :through => :questionnaire_pages
  has_many :questionnaire_pages, :dependent => :delete_all
  
  has_many :page_elements, :dependent => :delete_all
  has_many :elements, :through => :page_elements, 
    :order => "#{PageElement.table_name}.position"#, :include => :elements
#    :include => [ :element_flags, :flag_objs ]
  
  load 'flags.rb'
  include Flags
  Flags::setup :self => self, :flag_values_model => PageFlag
  
  Filter::setup self, :elements, :container =>  true do |elements, filter|
    # custom filtering -- look for at least 1 real question, otherwise get rid of
    # all subelements
#    puts "page has questions? " + self.has_question?(elements, filter).to_s
#    elements.clear if !self.has_question?(elements, filter)
  end
  
  def <=>(other)
    id <=> other.id
  end
  
  def has_question?(elements, params)
    filter = Filter.grab_hash_from params
    filter[:all] = nil
    elements.each do |e| # note -- reference objects don't respond to is_or_has_questions? but they are considered questions
#      puts "e.respond_to?('is_or_has_questions?') " + e.respond_to?('is_or_has_questions?').to_s
      puts "not clearing"
      return true if !e.respond_to?('is_or_has_questions?') || e.is_or_has_questions?(filter)
    end
    puts "clearing"
    false
  end
  
  # validates a page, but without preventing a +save+ opperation
  def validate!(instance)
    errors.clear #clear any errors already on the page.
    elements.each do |element|
      element.validate!(self, instance)
    end
    # Try validation callback
    self.send("validate_#{url_name}".to_sym, instance) if (self.respond_to?('validate_'+url_name))
  end
  
  def validated?(instance)
    validate!(instance)
    valid = errors.empty?
    # clear errors since we only want a boolean, no side effects
    errors.clear
    return valid
  end
  
  def invalid_elements
    @invalid_elements
  end
  
  def add_invalid_element(element)
    @invalid_elements ? @invalid_elements << element : @invalid_elements = Array(element)
  end
  
  def deep_copy
    copy = self.clone
    self.elements.each do |e| 
      e_copy = e.deep_copy
      e_copy.save!
      PageElement.create(:page => copy, :element => e_copy )
    end
    copy
  end
  
  def xml_children() elements end
  def never_has_children() false end

  def copy_answers(source_instance, dest_instance)
    elements.each do |element|
      element.copy_answer(source_instance, dest_instance)
    end
  end
end
