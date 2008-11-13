class CustomElement < Element
  self.abstract_class = true

  has_many :custom_element_required_sections, :foreign_key => :element_id

  def after_create_with_params(params)
    for model in [:appln_person, :emerg]
      for c in params[:required][model].keys
        section = custom_element_required_sections.new
        section.name = model.to_s
        section.attribute = c
        section.save!
      end
    end
  end

  def validate!(page, instance)
    @person = instance.viewer.person
    @emerg = @person.emerg
  
    for section in custom_element_required_sections
      if (section.name == 'appln_person' && [nil, ''].include?(@person.send(section.attribute))) ||
         (section.name == 'emerg' && [nil, ''].include?(@emerg.send(section.attribute)))
         
        page.errors.add_to_base("Attribute '#{section.attribute.to_s.camelize}' is required")
        page.add_invalid_element("#{section.name}_#{section.attribute}")
      end
    end
  end
end

