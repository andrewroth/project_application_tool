class CimHrdbAdmin < ActiveRecord::Base
  load_mappings
  include Legacy::Hrdb::CimHrdbAdmin
end
