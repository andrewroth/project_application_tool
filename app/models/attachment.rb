class Attachment < ActiveRecord::Base
  has_attachment :content_type => :image,
    :storage => :file_system,
    :path_prefix => 'public/attachments',
    :thumbnails => { :cas_logo => '175x175' }
end
