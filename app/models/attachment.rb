class Attachment < ActiveRecord::Base
  has_attachment :storage => :file_system,
    :path_prefix => 'public/attachments',
    :thumbnails => { :cas_logo => '175x175' }
end
