class Voie < ActiveRecord::Base
  validates_presence_of :name

  has_many :expositions

  def to_s
    name
  end
end
