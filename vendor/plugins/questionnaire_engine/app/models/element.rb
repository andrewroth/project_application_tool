load 'filter.rb'
load 'bsearch.rb'
load 'quicksort.rb'

class Element < ActiveRecord::Base
  set_table_name "#{QE.prefix}elements"
  include ModelXML
  include CustomElements
  include Filter
  
  load 'flags.rb'
  include Flags
  Flags::setup :self => self, :flag_values_model => ElementFlag
  
  has_many :page_elements, :dependent => :destroy
  has_many :pages, :through => :page_elements
  has_many :elements, :foreign_key => :parent_id, :order => :position
  acts_as_list :scope => :parent_id
  belongs_to :parent, :class_name => "Element", :foreign_key => :parent_id
  
  Filter::setup(self, :elements, :container => false) do |elements, filter|
    # custom filtering -- look for at least 1 real question, otherwise get rid of
    # all subelements
#    elements.clear if !is_or_has_questions?(filter)
  end
  
  def parent_id?() !parent_id.nil? end

  def is_or_has_questions?(*params)
    filter = Filter.grab_hash_from params
#    puts "element.filter " + filter.inspect
#    puts "element.is_or_has_questions? is_a? Question " + is_a?(Question).to_s
    return true if is_a? Question
    elements(filter).each do |e| 
#      puts "element.is_or_has_questions? respond? " + e.respond_to?('is_or_has_questions?').to_s + " return value " + e.is_or_has_questions?.to_s
      return true if !e.respond_to?('is_or_has_questions?') || e.is_or_has_questions?(filter)
    end
    false
  end
  
  def is_or_inherits_flag?(flag)
    return flags.include?(flag) || (!parent.nil? && parent.is_or_inherits_flag?(flag))
  end
  
  def validate!(page, instance)
    # add an error if this is required and not answered
    has_answer?(instance)  #this seems to be need for the links to be displayed correctly. No idea why though.
    if is_required? && !has_answer?(instance)
      page.errors.add_to_base("\"#{text}\" is required") 
      page.add_invalid_element(self)
    end
  end
  
  def save_answer(instance, params, answers)
    #at the Element level, this method doesn't do anything
  end
  
  def get_answer(instance, params = {})
    if question_table == 'answers'
      @answer = nil
      if params[:cache]
        if params[:cache_sorted]
          a_pos = params[:cache].bsearch_first{ |a| 
	    a.instance_id != instance.id ?
	      a.instance_id <=> instance.id : # match on instance id first
              a.question_id <=> id            #  then question id
	    }
          @answer = a_pos ? params[:cache][a_pos] : nil
	else
          @answer = params[:cache].detect {|a| a.instance_id == instance.id && a.question_id == id }
	end
      end
      if !params[:use_cache_only]
        @answer = instance.answers.detect {|a| a.question_id == id} if @answer.nil?
      end
      value = @answer.answer if @answer
    else
      if question_column && !question_column.empty? && instance.respond_to?(question_column.to_s)
        value = instance.send(question_column)
      end
    end
    value = custom_answer(instance) if respond_to?(:custom_answer) && value.nil?
    return value
  end
  
  def get_verbose_answer(instance, params)
    get_answer(instance, params)
  end

  def has_answer?(instance)
    !is_empty?(get_answer(instance))
  end
  
  def is_empty?(answer)
    '' == answer.to_s
  end
  
  def template
    self.class.to_s.downcase
  end
  
  def element_type
    read_attribute(:type).to_s
  end
  
  def element_type=(elem_type)
    type = elem_type
  end
  
  def deep_copy(new_parent = self.parent)
    copy = self.clone

    # not sure why, but active record loses the is_required setting below (possibly more)
    copy.save!

    # options
    self.question_options.each {|o| copy.question_options << o.clone } if self.respond_to?(:question_options)

    # settings
    copy.is_required = self.is_required
    copy.question_table = self.question_table
    copy.parent = new_parent

    # children
    self.elements.each {|e| copy.elements << e.deep_copy(copy)}

    # now resave
    copy.save!

    copy
  end
  
  def get_flag_value(flag_str)
    return all_flags[id].nil? ? nil : all_flags[id].include?(flag_str)
  end
  
  def xml_children() elements end

  # returns the questionnaire this element is on, going up the parent tree
  #
  # NOTE: assumes an element is only on one page, and a page is only in one questionnaire
  # 
  # if a block is passed every node up to the page (including this one) is yielded,
  #   plus the page, plus the questionnaire
  #
  def traverse_to_questionnaire
    node = self

    # guard against infinite loops
    visisted = { :self => true }

    yield node if block_given?
    while node.parent_id
      node = node.parent 
      yield node if block_given?
    end

    yield node.pages[0] if block_given?
    yield node.pages[0].questionnaires[0] if block_given?
    node.pages[0].questionnaires[0] if node.pages[0]
  end

  def text_summary(params = {})
    length = params[:length] || 20

    text_summary = text[0,length] + ('..' if text.length > length).to_s
    if params[:include_type]
      "#{type}<#{text_summary}>"
    else
      text_summary
    end
  end

  def is_nested_confidential?
    traverse_to_questionnaire do |node|
      if [Element,Page].include?(node.class) && node.is_confidential?
        return true
      end
    end

    false
  end

  @@cache = nil
  cattr_accessor :cache
  def elements_cached
    if @@cache.nil?
      puts 'initializing Element cache'
      @@cache = {}
      for e in Element.find(:all)
        if e.parent_id
          @@cache[e.parent_id] ||= []
          @@cache[e.parent_id] << e
        end
      end
    end
    @@cache[id] || []
  end
end
