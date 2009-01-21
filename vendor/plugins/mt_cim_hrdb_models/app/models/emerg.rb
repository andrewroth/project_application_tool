class Emerg < ActiveRecord::Base
  load_mappings

  belongs_to :person
end
