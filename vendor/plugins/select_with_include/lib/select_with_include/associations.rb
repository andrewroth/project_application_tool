module ActiveRecord
  module Associations
    module ClassMethods
      private
        def construct_finder_sql_with_included_associations(options, join_dependency)
          scope = scope(:find)
          sql = "SELECT #{column_aliases(join_dependency, options)} FROM #{(scope && scope[:from]) || options[:from] || quoted_table_name} "
          sql << join_dependency.join_associations.collect{|join| join.association_join }.join

          add_joins!(sql, options[:joins], scope)
          add_conditions!(sql, options[:conditions], scope)
          add_limited_ids_condition!(sql, options, join_dependency) if !using_limitable_reflections?(join_dependency.reflections) && ((scope && scope[:limit]) || options[:limit])

          add_group!(sql, options[:group], scope)
          add_order!(sql, options[:order], scope)
          add_limit!(sql, options, scope) if using_limitable_reflections?(join_dependency.reflections)
          add_lock!(sql, options, scope)

          return sanitize_sql(sql)
        end

        def construct_finder_sql_with_included_associations_old(options, join_dependency)
          scope = scope(:find)
          sql = "SELECT #{column_aliases(join_dependency, options)} FROM #{(scope && scope[:from]) || options[:from] || table_name} "
          sql << join_dependency.join_associations.collect{|join| join.association_join }.join

          add_joins!(sql, options, scope)
          add_conditions!(sql, options[:conditions], scope)
          add_limited_ids_condition!(sql, options, join_dependency) if !using_limitable_reflections?(join_dependency.reflections) && ((scope && scope[:limit]) || options[:limit])

          sql << "GROUP BY #{options[:group]} " if options[:group]

          add_order!(sql, options[:order], scope)
          add_limit!(sql, options, scope) if using_limitable_reflections?(join_dependency.reflections)
          add_lock!(sql, options, scope)

          return sanitize_sql(sql)
        end

        def column_aliases(join_dependency, options = {})
          join_dependency.joins.collect{|join| join.column_names_with_alias(options).collect{|column_name, aliased_name|
              "#{join.aliased_table_name}.#{connection.quote_column_name column_name} AS #{aliased_name}"}}.flatten.join(", ")
        end

        class JoinDependency # :nodoc:
          class JoinBase
            def column_names_with_alias(options = {})
              unless @column_names_with_alias
                @column_names_with_alias = []
                parsed_select = parse_select(options[:select])
                ([primary_key] + (column_names - [primary_key])).each_with_index do |column_name, i|
                  unless column_name != primary_key && parsed_select && !(parsed_select[table_name].member?(column_name) || parsed_select[table_name].member?('*') )
                    @column_names_with_alias << [column_name, "#{ aliased_prefix }_r#{ i }"]
                  end
                end
              end
              return @column_names_with_alias
            end

            def parse_select(select_options)
              return false if select_options.nil?
              tokens = select_options.gsub(' ', '').split(',')
              parsed = tokens.inject(Hash.new() {[]}) {|hash, token| words = token.split('.'); col = words.pop; tab = words.join('.'); hash[tab] = hash[tab] << col; hash}
              return false if parsed.keys.flatten.member? '*'
              return parsed
            end
          end
        end
    end 
  end
end
#ActiveRecord.__send__(:extend, ActiveRecordSelectWithInclude::Associations::ClassMethods)
