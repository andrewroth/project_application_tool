class Resource < ActiveRecord::Base
  has_attachment :storage => :file_system,
    :path_prefix => 'public/resources'
end
