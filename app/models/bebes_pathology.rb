class BebesPathology < ActiveRecord::Base
  belongs_to :bebe
  belongs_to :pathology
end
