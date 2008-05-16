class AddHeaderToCustomReportElements < ActiveRecord::Migration
  def self.up
    add_column :report_elements, :heading, :string
  end

  def self.down
    remove_column :report_elements, :heading
  end
end
