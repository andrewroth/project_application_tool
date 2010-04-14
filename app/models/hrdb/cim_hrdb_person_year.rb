class CimHrdbPersonYear < ActiveRecord::Base
  load_mappings
  include Legacy::Hrdb::CimHrdbPersonYear
end
