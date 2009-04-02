module ActiveRecord
  module Acts #:nodoc:
    module DatabaseBaseClass #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)  
      end
      
      module ClassMethods
        def acts_as_database_base_class(options = {})
          write_inheritable_attribute :acts_as_database_base_class_options, options
          class_inheritable_reader    :acts_as_database_base_class_options

          include ActiveRecord::Acts::DatabaseBaseClass::InstanceMethods
          extend ActiveRecord::Acts::DatabaseBaseClass::SingletonMethods          

          self.abstract_class = true

          if (RAILS_ENV =~ /test/).nil?
            establish_connection(configuration)
          else
            establish_connection(RAILS_ENV)
          end
        end
      end
      
      module SingletonMethods

        def table_exists?
          if connection.respond_to?(:tables)
            connection.tables.include? table_name.split('.').last
          else
            # if the connection adapter hasn't implemented tables, there are two crude tests that can be
            # used - see if getting column info raises an error, or if the number of columns returned is zero
            begin
              reset_column_information
              columns.size > 0
            rescue ActiveRecord::StatementInvalid
              false
            end
          end
        end

        def configuration
          (RAILS_ENV =~ /test/) ? "test" : "#{acts_as_database_base_class_options[:database]}_#{RAILS_ENV}"
        end
        
        def db_name
          db = ActiveRecord::Base.configurations[configuration]["database"]
          db ? db : ''
        end

        def table_name_prefix
          return '' unless acts_as_database_base_class_options
          return '' if RAILS_ENV == 'test'

          db_name.empty? ? '' : db_name + '.'
        end  
        
        def set_table_prefix_from_classname
          eval %|
            def #{name}.table_name_prefix
              super + "#{name.underscore}_"
            end
          |
        end
      end
      
      module InstanceMethods
      end
    end
  end
end
