class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.column :viewer_id,      :integer
      t.column :feedback_type,  :text
      t.column :description,    :text
      t.column :created_at,   :timestamp
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
