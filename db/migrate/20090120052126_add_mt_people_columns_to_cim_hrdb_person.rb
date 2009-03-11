class AddMtPeopleColumnsToCimHrdbPerson < ActiveRecord::Migration
  def self.up
    change_table(Person.table_name) do |t|
      t.string   "person_mname"
    end
  end

  def self.down
    change_table(Person.table_name) do |t|
      t.string   "person_mname"
    end
   end
end
