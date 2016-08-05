class Pathology < ActiveRecord::Base
  include PgSearch
  has_ancestry

  scope :leaves, -> { where(leaf: true) }

  def self.search(query)
    search_by_name(query) if query.present?
  end

  pg_search_scope :search_by_name,
                  against: :libelle,
                  using: { tsearch: { prefix: true, dictionary: 'french' } }

  has_many :bebes_pathologies, dependent: :destroy
  has_many :bebes, through: :bebes_pathologies

  def to_s
    libelle
  end

  def libelle_and_id
    { id: id, text: libelle }
  end
end
