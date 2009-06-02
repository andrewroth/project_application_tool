class AddProvinceToCampus < ActiveRecord::Migration
  CAMPUS_PROVINCES = {
    'UW' => 'ON',
    'UWO' => 'ON',
    'UofA' => 'AB',
    'UofC' => 'AB',
    'SFU' => 'BC',
    'UBC' => 'BC',
    'UofM' => 'AB',
    'Dal' => 'NS',
    'SMU' => 'NS',
    'CU' => 'ON',
    'MAC' => 'ON',
    "Queen's" => 'ON',
    'Ryerson' => 'ON',
    'UofG' => 'ON',
    'UofO' => 'ON',
    'UofT' => 'ON',
    'Windsor' => 'ON',
    'WLU' => 'ON',
    'York' => 'ON',
    'McGill' => 'QC',
    'UdeM' => 'QC',
    'UduQ' => 'QC',
    'UdeS' => 'QC',
    'Laval' => 'QC',
    'UofR' => 'SK',
    'UofS' => 'SK'
   } 

  def self.up
    add_column Campus.table_name, :province_id, :integer
    Person.reset_column_information

    for c, p in CAMPUS_PROVINCES
      campus = Campus.find_by_campus_shortDesc c
      province = Province.find_by_province_shortDesc p
      campus.province_id = province.id
      campus.save
    end
  end

  def self.down
    remove_column Campus.table_name, :province_id
  end
end
