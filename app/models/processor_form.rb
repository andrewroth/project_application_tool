class ProcessorForm < ActiveRecord::Base
  belongs_to :appln
  has_many :answers, :foreign_key => :instance_id
    
  def reference_instances() [] end

  def is_frozen
    false
  end
end
