namespace :db do
  task :legacy => :environment do
    abcs = ActiveRecord::Base.configurations
    abcs[RAILS_ENV]['database'] = ENV['in']
    abcs['test']['database'] = ENV['out']
    ActiveRecord::ConnectionAdapters::MysqlAdapter.class_eval do
      def supports_migrations?
        false
      end
    end
  end

  namespace :test do
    namespace :clone_structure do
      task :legacy => :environment do
        Rake::Task["db:legacy"].reenable
        Rake::Task["db:structure:dump"].reenable
        Rake::Task["db:test:purge"].reenable
        Rake::Task["db:test:clone_structure"].reenable

        Rake::Task["db:legacy"].invoke
        Rake::Task["db:test:clone_structure"].invoke
      end
    end

    namespace :prepare do
      desc "clones structure of the development db -> test db, and ciministry_development -> ciministry_test"
      task :all => :environment do
        Rake::Task["db:test:clone_structure"].invoke

        abcs = ActiveRecord::Base.configurations
        ENV['in'] = abcs['ciministry_development']['database']
        ENV['out'] = abcs['ciministry_test']['database']
        create_database(abcs['ciministry_test'])
        
        Rake::Task["db:test:clone_structure:legacy"].invoke
        
        ActiveRecord::Base.connection.execute "USE #{ENV['out']}" 
        ActiveRecord::Base.connection.execute "ALTER TABLE `c4c_intranet_test`.`accountadmin_viewer` DROP  FOREIGN KEY `FK_viewer_grp`;" 
        ActiveRecord::Base.connection.execute "ALTER TABLE `c4c_intranet_test`.`cim_hrdb_campus` DROP FOREIGN KEY `FK_campus_region`;"
        ActiveRecord::Base.connection.execute "ALTER TABLE `c4c_intranet_test`.`cim_hrdb_access`  DROP FOREIGN KEY `FK_access_person`;"
        ActiveRecord::Base.connection.execute "ALTER TABLE `c4c_intranet_test`.`cim_hrdb_emerg`  DROP FOREIGN KEY `FK_emerg_person`;"
      end
    end
  end
end
