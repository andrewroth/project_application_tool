module ActiveRecord
  class NilResultError < ActiveRecordError
  end

  module ConnectionAdapters
    class MysqlAdapter
      RETRY_COUNT = 3

      def log_error(m, e, r)
        RAILS_DEFAULT_LOGGER.info("MysqlAdapter FAIL: #{m} got #{e.class.name}.  Retries left: #{r}")
      end

      # retry lost connection / server gone away errors
      def execute_with_handle_connection_errors(sql, name = nil) #:nodoc:
        retries = RETRY_COUNT
        begin
          execute_without_handle_connection_errors sql, name
        rescue ActiveRecord::StatementInvalid, ActiveRecord::NilResultError => exception
          retries -= 1
          if retries > 0 and exception.message =~ /(Lost connection to MySQL server during query|MySQL server has gone away)|execute returned nil result/
            log_error('execute', exception, retries)
            reconnect!
            retry
          end
        end
      end
      alias_method_chain :execute, :handle_connection_errors

      # retry column methods that get nil back from execute
      def columns_with_handle_nils(table_name, name = nil) #:nodoc:
        retries = RETRY_COUNT
        begin
          columns_without_handle_nils table_name, name
        rescue NoMethodError => exception
          retries -= 1
          if retries > 0 and exception.message =~ /nil/
            log_error('column', exception, retries)
            reconnect!
            retry
          end
        end
      end
      alias_method_chain :columns, :handle_nils

      # retry select methods that get nil back from execute
=begin
      def select_with_handle_exceptions(table_name, name = nil) #:nodoc:
        retries = RETRY_COUNT
        begin
          result = select_without_handle_exceptions table_name, name
          raise ActiveRecord::NilResultError.new('select returned nil result') unless result
          return result
        rescue NoMethodError, ActiveRecord::NilResultError => exception
          retries -= 1
          log_error('select', exception, retries)
          if retries > 0 && /undefined method `all_hashes' for nil:NilClass|select returned nil result/
            reconnect!
            retry
          end
        end
      end
      alias_method_chain :select, :handle_exceptions
=end

    end
  end
end
