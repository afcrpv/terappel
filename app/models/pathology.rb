class Pathology < ActiveRecord::Base
  include PgSearch
  has_ancestry

  self.table_name = 'maladies'

  default_scope { where(code: '16').first.subtree.order('LOWER(name)') }

  def self.search(query)
    search_by_name(query) if query.present?
  end

  pg_search_scope :search_by_name,
                  against: :name,
                  using: { tsearch: { prefix: true, dictionary: 'french' } }

  has_many :bebes_pathologies, dependent: :destroy
  has_many :bebes, through: :bebes_pathologies

  def to_s
    name
  end

  def libelle_and_id
    { id: id, text: name }
  end
end
