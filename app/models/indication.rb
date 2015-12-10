class Indication < ActiveRecord::Base
  include PgSearch

  default_scope { order(:name) }

  has_many :expositions, inverse_of: :indication

  def self.search(query)
    search_by_name(query) if query.present?
  end

  pg_search_scope :search_by_name,
                  against: :name,
                  using: { tsearch: { prefix: true, dictionary: 'french' } }

  def to_s
    name
  end

  def name_and_id
    { 'id': id, 'text': name }
  end
end
