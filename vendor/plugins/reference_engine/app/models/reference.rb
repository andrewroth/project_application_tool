class Reference < Element
  has_many :reference_instances, :dependent => :destroy
  has_one :reference_attribute
  has_many :questionnaires, :through => :reference_attribute

  def Reference.REQUIRED_FIELDS() [ :title, :first_name, :last_name, :email ] end

  def questionnaire() questionnaires[0] end
  def questionnaire_id() r = reference_attribute; r ? r[:questionnaire_id] : nil end
  def questionnaire_id=(val)
    r = reference_attribute
    r = ReferenceAttribute.create(:reference_id => id) if r.nil?
    r.questionnaire_id = val
    r.save!
  end

  def save_answer(instance, params, answers)
    r = reference_instances.find_by_instance_id instance.id
    r.update_attributes!(params[:reference][id.to_s]) if params[:reference] && params[:reference][id.to_s]
  end

  def validate!(page, instance)
     reference = self.reference_instances.find_by_instance_id(instance.id)
     if reference.nil? || reference.email == "" || reference.first_name == "" || reference.last_name == "" || reference.title == ""
      page.errors.add_to_base("All reference fields must be completed ")
      page.add_invalid_element(self)
    end
  end

  def pdf_url() "#{text.underscore}_#{id}.pdf".gsub(" ","_") end

  def after_create_with_params(params)
    self.questionnaire_id = params[:element][:questionnaire_id]
  end
end
