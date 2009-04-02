module ActiveScaffold
  module Helpers
    # Helpers that assist with the rendering of a Form Column
    module FormColumnHelpers

      # the naming convention for overriding form fields with helpers
      def override_form_field(column)
        if active_scaffold_config.model != @record.class
          "#{@record.class.to_s.underscore}_#{column.name}_form_column"
        else
          "#{column.name}_form_column"
        end
      end
    end
  end
end
