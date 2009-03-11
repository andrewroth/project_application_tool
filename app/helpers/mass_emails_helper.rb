module MassEmailsHelper
  def project_options
    options = @projects.collect { |p| [ p.title, p.id ] }

    if @projects.length > 1
      options << [ 'Any', 'any' ]
    end

    options
  end
end
