class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggee, :polymorphic => true
end
