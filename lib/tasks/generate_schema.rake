require 'config/environment'
require 'active_record/schema_dumper'

ActiveRecord::Schema.verbose = false

spec = {
  :authservice_production => :all,
  :ciministry_production => %w(accountadmin_vieweraccessgroup accountadmin_viewer accountadmin_accessgroup 
      site_multilingual_label cim_hrdb_province cim_hrdb_gender cim_hrdb_emerg cim_hrdb_assignment 
      cim_hrdb_access cim_hrdb_person cim_hrdb_campus spt_ticket),
  :production => :all
}

def dump_db2(database, file = "db/schema", tables = :all)
  ActiveRecord::Base.establish_connection(database)

  # ignore tables to get the desired effect of only tables in the tables variable dumped
  if tables == :all
    ActiveRecord::SchemaDumper.ignore_tables = []
  else
    ActiveRecord::SchemaDumper.ignore_tables = ActiveRecord::Base.connection.tables - tables
  end

  ActiveRecord::SchemaDumper.include_schema_info = (ActiveRecord::Base.connection.current_database['spt'] != nil)
  File.open(file, "w") do |file|
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
  end
  ActiveRecord::SchemaDumper.include_schema_info = false
end

# I don't know why ActiveRecord::SchemaDumper doesn't put in the schema_info, you would think
# a schema dump is more valuable if you know what migration it was at
# This hack adds the option of including the schema info
class ActiveRecord::SchemaDumper
  cattr_accessor :include_schema_info
  @@include_schema_info = false

  def tables_with_schema_info(stream)
    tables_without_schema_info(stream)
    table('schema_info', stream) if include_schema_info && @connection.tables.include?('schema_info')
  end

  alias_method_chain :tables, :schema_info

=begin

  def self.dump_schema_if_possible(file)
    if ActiveRecord::Base.connection.tables.include?('schema_info')
      table('schema_info', file)
    end
  end
=end
end

namespace :db do
  namespace :schema do
    desc "Generates a schema from the Power to Change servers.  The databases and tables are specified in this file (#{__FILE__})"
    task :generate do
      spec.each_pair do |db, tables|
        dump_db2 db, "db/schema_#{db}.rb", tables
      end
    end
  end
end
