module RecordsAttributeUpdatedAt
  def self.included(base)
    base.class_eval do
      before_save :remember_attributes_changed
      after_save :update_attribute_updated_at

      def attributes_changed
        attributes.keys.find_all{ |att| self.send("#{att}_changed?") }
      end 

      def remember_attributes_changed
        @attributes_changed = attributes_changed
      end

      def update_attribute_updated_at
        attributes_changed.each do |att|
          next if %w(updated_at created_at).include?(att)
          #table_name = self.class.table_name.split('.').last
          table_name = self.class.table_name
          return unless person
          updated_at = person.attributes_updated_ats.find_or_create_by_table_name_and_attr_name(table_name, att)
          updated_at.updated_at = DateTime.now
          updated_at.save!
        end
        puts "Record attributes changed: #{attributes_changed.inspect}"
      end

      def attribute_updated_at(att)
        person.attributes_updated_ats.find_by_table_name_and_attr_name(self.class.table_name, att).try(:updated_at)
      end

      def changed_since(cutoff_date)
        table_name = self.class.table_name
        person.attributes_updated_ats.find(:all, :conditions => [ "table_name = ? AND updated_at >= ?", table_name, cutoff_date ])
      end

      def changed_since_hash(cutoff_date)
        h = Hash[changed_since(cutoff_date).collect{ |att| [ att.attr_name, self.send(att.attr_name) ] }]
        h.delete_if{ |k,v| v == "" || v.nil? }
      end
    end
  end
end
