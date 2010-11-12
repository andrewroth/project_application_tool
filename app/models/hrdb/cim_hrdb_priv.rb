class CimHrdbPriv < ActiveRecord::Base
  load_mappings
  include Legacy::Hrdb::CimHrdbPriv
end
