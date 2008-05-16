class FixEventGroupHidden < ActiveRecord::Migration
  def self.up
    for form in Form.find :all
      if form.hidden.nil?
        form.hidden = false
        form.save!
      end
    end
  end

  def self.down
  end
end
