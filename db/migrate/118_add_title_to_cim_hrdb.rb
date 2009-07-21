class AddTitleToCimHrdb < ActiveRecord::Migration
  def self.default_db()
    ActiveRecord::Base.configurations[RAILS_ENV]["database"]
  end

  def self.up
    unless Title.table_exists?
      create_table Title.table_name do |t|
        t.string :desc
      end
    end

    Title.find_or_create_by_desc 'Mr.'
    Title.find_or_create_by_desc 'Ms.'
    Title.find_or_create_by_desc 'Mrs.'
    Title.find_or_create_by_desc 'Dr.'
    Title.find_or_create_by_desc 'Rev.'

    begin
      add_column Person.table_name, :title_id, :integer
    rescue
    end
  end

  def self.down
    drop_table(Title.table_name) if Title.table_exists?

    begin
      remove_column Person.table_name, :person_id
    rescue
    end
  end
end
