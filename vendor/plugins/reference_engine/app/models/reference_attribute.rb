class ReferenceAttribute < ActiveRecord::Base
  set_table_name "#{QE.prefix}reference_attributes"

  belongs_to :questionnaire
  belongs_to :reference
end
