class MakeAllCurrentPrepItemsPaperwork < ActiveRecord::Migration
  def self.up
    PrepItem.update_all "paperwork = true"
  end

  def self.down
    PrepItem.update_all "paperwork = false"
  end
end
