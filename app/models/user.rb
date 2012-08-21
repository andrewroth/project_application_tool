class User < ActiveRecord::Base
  load_mappings
  include Common::Core::User
  include Common::Core::Ca::User
  include Common::Pat::User
  include ViewerMethods

  def prep_item_applies_to(prep_item)
  end
end
