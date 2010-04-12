class CimHrdbStaff < ActiveRecord::Base
  load_mappings
  include Legacy::Hrdb::CimHrdbStaff
end

