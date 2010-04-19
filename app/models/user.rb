class User < ActiveRecord::Base
  load_mappings
  include Common::Core::User
  include Common::Core::Ca::User
  include ViewerMethods
end
