class CimHrdbAddress < ActiveRecord::Base
  load_mappings
  self.abstract_class = true
  include Legacy::Hrdb::CimHrdbAddress
end
