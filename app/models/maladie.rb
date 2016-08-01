class Maladie < ActiveRecord::Base
  has_ancestry

  scope :leaves, -> { joins("LEFT JOIN #{table_name} AS c ON c.#{ancestry_column} = CAST(#{table_name}.id AS text) OR c.#{ancestry_column} = #{table_name}.#{ancestry_column} || '/' || #{table_name}.id").group("#{table_name}.id").having("COUNT(c.id) = 0").order("#{table_name}.ancestry NULLS FIRST") }
end
