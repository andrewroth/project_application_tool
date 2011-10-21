# It seems Application is NOT a name you want to use; rails
# breaks in baffling places.  So I named it appln, it's shorter
# anyways!
# 
class Appln < ActiveRecord::Base
  belongs_to :viewer
  belongs_to :form
  
  has_many :answers, :foreign_key => :instance_id
  has_many :profiles
  
  has_many :reference_instances, :class_name => 'ApplnReference', :foreign_key => 'instance_id', :order => :reference_id
  
  belongs_to :preference1, :class_name => "Project", :foreign_key => :preference1_id
  belongs_to :preference2, :class_name => "Project", :foreign_key => :preference2_id
  
  has_one :processor_form_ref, :class_name => 'ProcessorForm'
  
  def acceptances
    profiles.reject { |p| p.class != Acceptance }
  end
  
  def person() viewer.person end
  def status() profile.status end
  def status=(val) profile.status = val end
  def completed_at() profile.completed_at end
  def accepted_at() profile.accepted_at end
  def withdrawn_at() profile.withdrawn_at end
  def submitted?() profile.class == Applying && 
           profile.status != 'started' && profile.status != 'unsubmitted' end
  def withdrawn?() profile.class == Withdrawn end
  def completed?() profile.class == Applying && profile.status == 'completed' end
  def accepted?() profile.class == Acceptance end
  
  def Appln.find_all_by_status(s, options = {})
    options[:include] ||= []
    options[:include] = [ options[:include] ] if options[:include].class == Symbol
    options[:include] << :profiles
    # expects :conditions as an array with 2 elements, the second being a hash
    if !options.has_key?("conditions")
      options[:conditions] = ['', {}]
    else
      options[:conditions][0] += " and "  # append status to conditions
    end
    options[:conditions][0] += "status = :status"
    options[:conditions][1][:status] = s
    Appln.find(:all, options)
  end
  
  def profile
    p = profiles[0]
    if p.nil?
      p = Applying.new :appln_id => id, :status => 'started', :viewer_id => viewer_id
      p.save!
      profiles << p
    end
    p
  end
  
  def editable?
    profile.class == Applying && 
      Appln.unsubmitted_statuses.include?(status)
  end
  
  # The statuses that mean an application has NOT been submitted
  def self.unsubmitted_statuses
    %w(started unsubmitted)
  end
  
  # The statuses that mean an applicant is NOT ready to evaluate
  def self.not_ready_statuses
    %w(submitted withdrawn)
  end

  # The statuses that mean an applicant IS ready to evaluate
  def self.ready_statuses
    %w(completed)
  end
  
  def self.statuses
    SpApplication.unsubmitted_statuses | SpApplication.not_ready_statuses | SpApplication.ready_statuses
  end
  
  def self.cost
    if Time.now < Time.parse('2/25/'+SpApplication::YEAR.to_s+' 4:00')
      return 25
    else
      return 35
    end
  end
  
  def processor_form
    return processor_form_ref || @processor_form || @processor_form = ProcessorForm.create(:appln_id => id)
  end
  
  def has_paid?
    self.payments.each do |payment|
      return true if payment.approved?
    end
    return false
  end
  
  def unsubmit_email
    SpApplicationMailer.deliver_unsubmitted(self)
  end
  
  def self.questionnaire() 
    @@questionnaire ||= Questionnaire.find_by_id(1, :include => :pages, :order => 'position')
  end
  
  # mark the whole application as complete if it's all finished (including refs)
  def complete(ref = nil)
    return false unless self.submitted?
    #return false if self.reference_instances.empty?  # no references even saved (assuming all apps have at least 1)
    # ^^^ this shouldn't affect applyings.. and needs to be removed for apps w/o refs
    
    not_done = false
    self.reference_instances.each do |r|
      not_done ||= !(r.completed? || r.bypassed? || r == ref)   # if ref completed, or about to be completed
    end
    return false if not_done
    return self.profile.complete!
  end
  
  # mark the whole application as complete if it's all finished (including refs)
  def accept
    if profile.project.event_group.automatic_acceptance && !profile.appln.form.questionnaire.references.present?
      profile.manual_update :type => 'Acceptance', :appln_id => self.id, :project_id => self.profile.project.id,
        :support_claimed => 0, :support_coach_id => nil,
        :accepted_by_viewer_id => self.viewer.id, :as_intern => false,
        :viewer_id => self.viewer_id, :viewer => self.viewer, :locked_by => nil

      profile = Profile.find(self.profile.id) # reload to make the new type catch
      profile.accept!

      SpApplicationMailer.deliver_accepted(profile, @viewer.email)
    end
  end

   # The :frozen? method lets the QuestionnaireEngine know to not allow
  # the user to change the answer to a question.
  def frozen?
    !%w(started unsubmitted).include?(self.status)
  end
  
  def can_change_references?
    %w(started unsubmitted).include?(self.status)
  end
  
  def remove_from_all_piles(app)
    ProcessorPile.delete_all "appln_id = #{app.id}"
    Acceptance.delete_all "appln_id = #{app.id}"
  end
  
  $last_delete_those_with_invalid_viewers ||= 2.days.ago

  def Appln.delete_those_with_invalid_viewers
    return Time.now
    return $last_delete_those_with_invalid_viewers unless $last_delete_those_with_invalid_viewers <= 24.hours.ago
    m = "Performing Appln.delete_those_with_invalid_viewers (last one was at #{$last_delete_those_with_invalid_viewers}"
    #puts m;
    logger.info m
    $last_delete_those_with_invalid_viewers = Time.now

    as = Appln.find(:all, :include => :viewer).reject &:viewer
    for a in as
      m = "Deleteting app #{a.id} status #{a.status} viewer #{a.viewer_id}"
      #puts m; 
      logger.info m

      a.destroy
    end
  end
  
  def pref1
    self.preference1_id ? self.preference1.title : ''
  end
  
  def pref2
    self.preference2_id ? self.preference2.title : ''
  end
  
  def accepted
    accepts = self.nil? ? nil : Acceptance.find_all_by_appln_id(self.id)
    acceptance_obj = accepts.nil? ? nil : accepts.find { |acc| acc.project.event_group_id == @eg.id }
    acceptance = acceptance_obj ? acceptance_obj.project.title : ''
  end
  
  # returns an array of hashes with :text and :instance_id
  #
  #   [ { :text => 'Reference Text', :instance_id => <ReferenceInstance id> } ... ]
  #
  # the list of references is taken from the form, so there may not be an instances
  # yet of that reference, in which case the instance_id is nil
  #   
  def references_text_list
    form.questionnaire.references.collect{ |ref|
      ri = reference_instances.detect{ |ri| ri.reference_id == ref.id }
      
      { :text => ref.text, :instance_id => (ri ? ri.id : nil) }
    }
  end

  def copy_answers(source_instance)
    if source_instance.form != form
      throw "In copy_answers, the source and destination need to have same form."
    else
      form.questionnaire.copy_answers(source_instance, self)
    end

    references = self.form.questionnaire.references
    for ref_elem in references
      ref_source_instance = source_instance.reference_instances.find_by_reference_id ref_elem.id
      if ref_source_instance
        ref_inst = self.reference_instances.find_or_create_by_instance_id_and_reference_id self.id, ref_elem.id
        # make sure the questionnaire still matches -- ie the questionnaire the reference
        # uses may have changed since the source appln was created
        source_questionnaire = ref_source_instance.try(:reference).try(:questionnaire)
        dest_questionnaire = ref_elem.try(:questionnaire)
        if !source_questionnaire.nil? && source_questionnaire == dest_questionnaire
          dest_questionnaire.copy_answers(ref_source_instance, ref_inst)
        else
          logger.info "Warning: when copying appln #{source_instance.id} to #{id}, reference element #{ref_elem.id} is different (was #{source_questionnaire.try(:id)} is now #{dest_questionnaire.try(:id)})"
        end
      else
        logger.info "Warning: when copying appln #{source_instance.id} to #{id}, reference element #{ref_elem.id} couldn't find an instance in the source app to copy answers from."
      end
    end
  end
end
