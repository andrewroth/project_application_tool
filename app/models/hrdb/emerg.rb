class Emerg < ActiveRecord::Base
  load_mappings
  include Legacy::Hrdb::Emerg
end
