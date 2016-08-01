class Malformation < ActiveRecord::Base
  has_ancestry

  validates_presence_of :libelle
  validates_uniqueness_of :libelle

  has_many :bebes_malformations, dependent: :destroy
  has_many :bebes, through: :bebes_malformations

  scope :leaves, -> { joins("LEFT JOIN #{table_name} AS c ON c.#{ancestry_column} = CAST(#{table_name}.id AS text) OR c.#{ancestry_column} = #{table_name}.#{ancestry_column} || '/' || #{table_name}.id").group("#{table_name}.id").having("COUNT(c.id) = 0").order("#{table_name}.ancestry NULLS FIRST") }

  def to_s
    libelle
  end

  def libelle_and_id
    { id: id, text: libelle }
  end
end
