class Produit < ActiveRecord::Base
  attr_accessible :name, :oldid
  has_many :expositions, inverse_of: :produit
  has_many :dossiers, :through => :expositions

  default_scope order(:name)

  def to_s
    name
  end

  def name_and_id
    {'id' => id, 'text' => name}
  end
end
