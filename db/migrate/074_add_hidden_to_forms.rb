class AddHiddenToForms < ActiveRecord::Migration
  def self.up
    begin
      add_column :forms, :hidden, :boolean
    rescue
    end
    
    Form.find(:all).each do |f|
      f.hidden = f[:name] != 'Project Application'
      f.save!
    end
  end

  def self.down
    remove_column :forms, :hidden, :boolean
  end
end
