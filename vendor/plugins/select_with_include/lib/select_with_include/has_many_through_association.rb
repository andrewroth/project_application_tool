  module ActiveRecord
    module Associations
      class HasManyThroughAssociation
        def find(*args)
          options = Base.send(:extract_options_from_args!, args)

          conditions = "#{@finder_sql}"
          if sanitized_conditions = sanitize_sql(options[:conditions])
            conditions << " AND (#{sanitized_conditions})"
          end
          options[:conditions] = conditions

          if options[:order] && @reflection.options[:order]
            options[:order] = "#{options[:order]}, #{@reflection.options[:order]}"
          elsif @reflection.options[:order]
            options[:order] = @reflection.options[:order]
          end

          options[:select]  = construct_select(options[:select], options[:include])
          options[:from]  ||= construct_from
          options[:joins]   = construct_joins(options[:joins])
          options[:include] = @reflection.source_reflection.options[:include] if options[:include].nil?

          merge_options_from_reflection!(options)

          # Pass through args exactly as we received them.
          args << options
          @reflection.klass.find(*args)
        end
      end
    end
  end
