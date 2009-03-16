# causes rake db:test:prepare to crash
# on schema clone

class RemoveBlobIndexes < ActiveRecord::Migration
  def self.up
    begin
      execute "DROP INDEX `travel_segments_notes` ON travel_segments"
      execute "DROP INDEX `feedbacks_feedback_type` ON feedbacks"
    rescue
    end
  end

  def self.down
    begin
      execute "CREATE INDEX travel_segments_notes ON travel_segments (notes(10));"
      execute "CREATE INDEX feedbacks_feedback_type ON feedbacks (feedback_type(10));"
    rescue
    end
  end
end
