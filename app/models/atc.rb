class Atc < ActiveRecord::Base
  has_many :produits, through: :classifications
  has_many :classifications, dependent: :destroy
end
