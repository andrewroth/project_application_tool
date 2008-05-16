class ModifyApplnReferences < ActiveRecord::Migration
  def self.up
    begin
      add_column :appln_references, :element_id, :integer, :null => false
    rescue
    end
    
    ApplnReference.set_table_name 'appln_references'
    ApplnReference.reset_column_information
    ApplnReference.inheritance_column = 'not_type'  # after deleting the peer_reference.rb model, etc. we get errors on migrate
    
    ApplnReference.transaction do  
      ApplnReference.find(:all).each do |a|
        if a.type_before_type_cast == 'PeerReference'
          a.element_id = 281
        elsif a.type_before_type_cast == 'PastorReference'
          a.element_id = 282
        elsif a.type_before_type_cast == 'StaffReference'
          a.element_id = 283
        end
        a.save
      end
      
    end
    
    remove_column :appln_references, :type
  end

  def self.down
    remove_column :appln_references, :element_id
    add_column :appln_references, :type, :string
  end
end
