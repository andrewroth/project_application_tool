class Title < ActiveRecord::Base
  load_mappings
  include Legacy::Hrdb::Title
end
