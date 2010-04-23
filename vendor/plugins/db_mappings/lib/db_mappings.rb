ActiveRecord::Base.class_eval do
  @mapping_filename = File.join(RAILS_ROOT, 'config', 'mappings.yml')
  if File.exists?(  @mapping_filename )
    @@map_hash ||= YAML::load(ERB.new(File.read(@mapping_filename)).result)

    # Convert the databases list of comma-separated values in an array
    if @@map_hash && @@map_hash['databases']
      for db, tables_list in @@map_hash['databases']
        @@map_hash['databases'][db] = tables_list.gsub(/\s/,'').split(',')
      end
    end

    def self.load_mappings
      if @@map_hash 
        # Set the table name for the class, if defined
        if @@map_hash['tables'] && @@map_hash['tables'][self.name.underscore]
          set_table_name @@map_hash['tables'][self.name.underscore]
        elsif db = @@map_hash['databases'].find{ |db, tables| tables.index(self.name.underscore) }.try(:first)
          db_name = ActiveRecord::Base.configurations[db]["database"]
          set_table_name "#{db_name}.#{table_name.split('.').last}"
        end

        handle_databases
        map_column_names
      end
    end

    # For mappings done programmatically with the lib_path classes, this method is useful
    # in getting things started.  You can easily make stubs by passing a map in the
    # format :attribute => 'code to eval to return value'.  Once the app is running with these
    # stubs you can go one by one and implement true get/set methods.
    def self.doesnt_implement_attributes(atts)
      for at, val in atts
        val = "''" if val.class == String && val.empty?
        self.class_eval "def #{at}() #{val}; end"
        self.class_eval "def #{at}=(val) throw '#{at}=(val) is not implemented' end"
      end
    end

    # =============================================================================
    # = This method is the key to column mapping. It will check the map hash for  =
    # = the proper attribute name corresponding to the attribute passed in.       =
    # =============================================================================
    def self._(column, table = self.name.underscore)
      column, table = column.to_s, table.to_s
      @@map_hash && @@map_hash[table] && @@map_hash[table][column] ? @@map_hash[table][column] : column
    end

    def self.__(column, table = self.name.underscore)
      model = self.is_a?(ActiveRecord::Base) ? self.class : table.to_s.camelize.constantize
      "#{model.table_name}.#{self._(column, table)}"
    end

    def _(column, table)
      ActiveRecord::Base._(column, table).to_s
    end

    def __(column, table)
      ActiveRecord::Base.__(column, table).to_s
    end
  else
    
    def self.load_mappings
      
    end
    
    def self._(column, table = self.name.underscore)
      column.to_s
    end
    
    def self.__(column, table = self.name.underscore)
      "#{self.table_name}.#{column.to_s}"
    end

    def _(column, table)
      ActiveRecord::Base._(column, table).to_s
    end

    def __(column, table)
      ActiveRecord::Base.__(column, table).to_s
    end
   end

  protected

    def self.handle_databases
      # Establish connection based on the databases entry
      if @@map_hash['databases']
        found = false
        for db, tables in @@map_hash['databases']
          if tables.include?(self.name.underscore)
            self.class_eval "establish_connection '#{db}'"
            # Prepend database for joins
            unless table_name['.']
              db_name = ActiveRecord::Base.configurations[db]["database"]
              self.set_table_name "#{db_name}.#{table_name}"
            end
            found = true
            break
          end
        end
        # Set database for models using default RAILS_ENV connection as well (ie not in database: list)
        unless found || table_name['.']
          @@default_db ||= ActiveRecord::Base.configurations[RAILS_ENV]["database"]
          self.set_table_name "#{@@default_db}.#{table_name}"
        end
      end
    end

    def self.map_column_names
      # Map non-standard column names to the names used in the code
      if @@map_hash[self.name.underscore]
        @@map_hash[self.name.underscore].each do |standard, custom|
          unless standard.to_s == 'id'
            self.class_eval "def #{standard}() #{custom}; end"
            self.class_eval "def #{standard}=(val) self[:#{custom}] = val; end"
          end
        end
        # Set the primary key to something besides 'id'
        if @@map_hash[self.name.underscore]['id']
          self.class_eval "set_primary_key :#{@@map_hash[self.name.underscore]['id']}"
        end
      end
    end

end
