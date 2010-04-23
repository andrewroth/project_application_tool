# ValidatesNoAssociationData
module ActiveRecord
  class Base
    def self.validates_no_association_data(*attr_names)
      before_destroy do |record|
        attr_names.each { |assoc|
          if record.send(assoc).present?
            record.errors.add(assoc, " association has data")
          end
        }
        record.errors.empty?
      end
    end
  end
end