class BebesMalformation < ActiveRecord::Base
  belongs_to :bebe
  belongs_to :malformation
end
