module ActiveSupport::Dependencies::Loadable
  # helper method to require a rails root model dependency
  def require_model(f)
    require_dependency "#{RAILS_ROOT}/app/models/#{f}"
  end
end
