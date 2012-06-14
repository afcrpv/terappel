class Voie < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name

  has_many :expositions

  def to_s
    name
  end
end
