class Dci < ActiveRecord::Base
  has_many :produits, through: :compositions
  has_many :compositions, dependent: :destroy

  default_scope {order(:libelle)}

  def self.search_by_name(string)
    where("LOWER(libelle) like ?", "%#{string}%")
  end

  def to_s
    libelle
  end

  def name_and_id
    {'id' => id, 'text' => libelle}
  end
end
