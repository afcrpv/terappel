class Classification < ActiveRecord::Base
  belongs_to :produit
  belongs_to :atc
end
