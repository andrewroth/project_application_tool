class RenameEngineSchema < ActiveRecord::Migration
  def self.up
    # Engines does this automatically -AR
    
    # for engines 1.2
#    rename_table :engine_schema_info, :plugin_schema_info
  end

  def self.down
#    rename_table :plugin_schema_info, :engine_schema_info
  end
end
