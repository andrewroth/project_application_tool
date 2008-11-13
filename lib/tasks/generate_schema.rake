
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

  File.open(file, "w") do |file|
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
  end
end

namespace :db do
  namespace :schema do
    desc "Generates a schema from the Power to Change servers.  The databases and tables are specified in this file (#{__FILE__})"
    task :generate => :environment do
      require 'active_record/schema_dumper'
      ActiveRecord::Schema.verbose = false

      spec.each_pair do |db, tables|
        dump_db2 db, "db/schema_#{db}.rb", tables
      end
    end
  end
end
