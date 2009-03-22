module ActiveRecord
  module ConnectionAdapters
    class MysqlAdapter
      def execute(sql, name = nil) #:nodoc:
        reconnect_lost_connections = true
        begin
          log(sql, name) { @connection.query(sql) }
        rescue ActiveRecord::StatementInvalid => exception
          RAILS_DEFAULT_LOGGER.info("ActiveRecord::StatementInvalid Error: #{exception.message}\n#{exception.backtrace.join("\n")}")
          if reconnect_lost_connections and exception.message =~ /(Lost connection to MySQL server during query|MySQL server has gone away)/
            reconnect_lost_connections = false
            reconnect!
            retry
          elsif exception.message.split(":").first =~ /Packets out of order/
            raise ActiveRecord::StatementInvalid, "'Packets out of order' error was received from the database. Please update your mysql bindings (gem install mysql) and read http://dev.mysql.com/doc/mysql/en/password-hashing.html for more information.  If you're on Windows, use the Instant Rails installer to get the updated mysql bindings."
          else
            raise
          end
        end
      end
    end
  end
end
