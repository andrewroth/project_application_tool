class CustomElement < Element
  self.abstract_class = true

  has_many :custom_element_required_sections, :foreign_key => :element_id
  has_many :custom_element_hidden_sections, :foreign_key => :element_id

  def after_create_with_params(params)
    for model in [:appln_person, :emerg]
      next unless params[:required][model]

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
    @emerg = @person.get_emerg
  
    for section in custom_element_required_sections
      sa = section.attribute
      sa_assoc = (sa =~ /(.*)_id/; $1)
      case sa
      when 'local_country'
        sa = 'person_local_country_id'
      when 'perm_country'
        sa = 'person_country_id'
      end

      if section.name == 'emerg' && %w(health_coverage_state health_number health_province_id).include?(section.attribute)
        if @emerg.health_coverage_country == "CAN" && [nil, ''].include?(@emerg.send(section.attribute))
          page.errors.add_to_base("Attribute '#{section.attribute.humanize}' is required")
          page.add_invalid_element("#{section.name}_#{section.attribute}")
        end
      elsif section.name == 'emerg' && %w(medical_plan_number medical_plan_carrier).include?(section.attribute)
        if @emerg.health_coverage_country == "USA" && [nil, ''].include?(@emerg.send(section.attribute))
          page.errors.add_to_base("Attribute '#{section.attribute.humanize}' is required")
          page.add_invalid_element("#{section.name}_#{section.attribute}")
        end
      elsif (section.name == 'appln_person' && (
            [nil, ''].include?(@person.send(sa)) ||
            sa_assoc && @person.send(sa_assoc).nil?)) ||
         (section.name == 'emerg' && [nil, ''].include?(@emerg.send(section.attribute)))
         
        page.errors.add_to_base("Attribute '#{section.attribute.humanize}' is required")
        page.add_invalid_element("#{section.name}_#{section.attribute}")
      end
    end
  end
end

