class YearInSchool < ActiveRecord::Base
  load_mappings
  include Legacy::Hrdb::YearInSchool
end
