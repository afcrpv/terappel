class Dci < ActiveRecord::Base
  has_many :produits, through: :compositions
  has_many :compositions, dependent: :destroy
end
