module ActiveRecord
  module ConnectionAdapters
    class MysqlAdapter
      RETRY_COUNT = 3

      # retry lost connection / server gone away errors
      def execute_with_handle_connection_errors(sql, name = nil) #:nodoc:
        retries = RETRY_COUNT
        begin
          execute_without_handle_connection_errors sql, name
        rescue ActiveRecord::StatementInvalid => exception
          RAILS_DEFAULT_LOGGER.info("MysqlAdapter FAIL: execute got StatementInvalid.  Retries left: #{retries}")
          if retries > 0 and exception.message =~ /(Lost connection to MySQL server during query|MySQL server has gone away)/
            reconnect!
            retries -= 1
            retry
          end
        end
      end
      alias_method_chain :execute, :handle_connection_errors

      # retry column methods that get nil back from execute
      def columns_with_handle_executions(table_name, name = nil) #:nodoc:
        retries = RETRY_COUNT
        begin
          columns_without_handle_executions table_name, name
        rescue NoMethodError => exception
          RAILS_DEFAULT_LOGGER.info("MysqlAdapter FAIL: column NoMethodError.  Retries left: #{retries}")
          if retries > 0 and  exception.message =~ /(You have a nil object when you didn't expect it!)/
            reconnect!
            retries -= 1
            retry
          end
        end
      end
      alias_method_chain :columns, :handle_executions

    end
  end
end
