# Year in school is a customisable list belonging to ministry?
class SchoolYear < ActiveRecord::Base
  load_mappings
  include Common::Core::SchoolYear
end
