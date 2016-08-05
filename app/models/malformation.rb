class Malformation < ActiveRecord::Base
  include PgSearch
  has_ancestry

  scope :leaves, -> { where(leaf: true) }

  has_many :bebes_malformations, dependent: :destroy
  has_many :bebes, through: :bebes_malformations

  def self.search(query)
    search_by_name(query) if query.present?
  end

  pg_search_scope :search_by_name,
                  against: :libelle,
                  using: { tsearch: { prefix: true, dictionary: 'french' } }

  def to_s
    libelle
  end

  def libelle_and_id
    { id: id, text: libelle }
  end
end
