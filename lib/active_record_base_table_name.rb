class ActiveRecord::Base
    def self.table_exists?
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
 
end
