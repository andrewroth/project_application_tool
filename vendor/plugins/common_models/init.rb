def path(p)
  "#{File.dirname(__FILE__)}/app/models/#{p}"
end

ActiveSupport::Dependencies.load_paths += [ 
  path('ciministry'), 
  path('ciministry/accountadmin'),
  path('ciministry/cim_hrdb'),
  path('ciministry/site'),
  path('ciministry/spt'),
  path('authservice')
]
