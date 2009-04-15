module ActiveRecord
  class NilResultError < ActiveRecordError
  end

  module ConnectionAdapters
    class MysqlAdapter
      RETRY_COUNT = 3

      def log_error(m, e = nil, r = nil)
        msg = "MysqlAdapter FAIL: #{m}"
        msg << " got #{e.class.name}.  Message: \"#{e.message}\"" if e && e.is_a?(Exception)
        msg << " #{e}" if e.class == String
        msg << " Retries left: #{r}" if r
        RAILS_DEFAULT_LOGGER.info msg
      end

      # retry lost connection / server gone away errors
      def execute_with_handle_connection_errors(sql, name = nil) #:nodoc:
        retries = RETRY_COUNT
        begin
          execute_without_handle_connection_errors sql, name
        rescue ActiveRecord::StatementInvalid => exception
          retries -= 1
          log_error('execute', exception, retries)
          if retries > 0 and exception.message =~ /(Lost connection to MySQL server during query|MySQL server has gone away)/
            log_error('execute', 'retrying')
            reconnect!
            retry
          else
            log_error('execute', 'giving up')
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
          log_error('column', exception, retries)
          if retries > 0 and exception.message =~ /nil/
            log_error('column', 'retrying')
            reconnect!
            retry
          else
            log_error('column', 'giving up')
          end
        end
      end
      alias_method_chain :columns, :handle_nils

      # retry select methods that get nil back from execute
      def select_with_handle_exceptions(table_name, name = nil) #:nodoc:
        retries = RETRY_COUNT
        begin
          result = select_without_handle_exceptions table_name, name
          raise ActiveRecord::NilResultError.new('select returned nil result') if result.nil?
          return result
        rescue NoMethodError, ActiveRecord::NilResultError => exception
          retries -= 1
          log_error('select', exception, retries)
          if retries > 0 && exception.message =~ /undefined method `all_hashes' for nil:NilClass|select returned nil result/
            log_error('select', 'retrying')
            reconnect!
            retry
          else
            log_error('select', 'giving up')
          end
        end
      end
      alias_method_chain :select, :handle_exceptions

    end
  end
end
