require 'ored_list'
class Produit < ActiveRecord::Base
  include PgSearch
  has_many :expositions, inverse_of: :produit
  has_many :dossiers, through: :expositions

  has_many :dcis, through: :compositions
  has_many :compositions, dependent: :destroy
  has_many :atcs, through: :classifications
  has_many :classifications, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  default_scope {order(:name)}

  def self.search(query)
    search_by_name(query) if query.present?
  end

  pg_search_scope :search_by_name,
                  against: :name,
                  using: { tsearch: { prefix: true, dictionary: 'french' } }

  def to_s
    return dci if dci.present?
    name
  end

  def dci
    dcis.map(&:libelle).join("-")
  end

  def name_and_id
    { 'id': id, 'text': name }
  end
end
