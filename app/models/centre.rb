class Centre < ActiveRecord::Base
  has_many :users
  has_many :dossiers

  validates_presence_of :name
  validates_uniqueness_of :name

  extend FriendlyId
  friendly_id :name, :use => :slugged
end
