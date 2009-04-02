# testing and sqlite3 should use one database
ActiveRecord::Base.table_name_prefix = ActiveRecord::Base.configurations[RAILS_ENV]['database'] + '.' unless
  RAILS_ENV == 'test' ||
  ActiveRecord::Base.configurations[RAILS_ENV]['dbfile'] ||
  (caller.find{ |c| c["rake"] || c["test"] } && !caller.find{ |c| c["mongrel"] || c["webrick"] })

