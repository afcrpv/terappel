class Centre < ActiveRecord::Base
  attr_accessible :name, :code

  has_many :users
  has_many :dossiers
  validates_presence_of :name
  validates_uniqueness_of :name

  extend FriendlyId
  friendly_id :name, :use => :slugged

  default_scope order(:code)
end
