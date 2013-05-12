class Centre < ActiveRecord::Base
  has_many :users
  has_many :dossiers
  validates :name, uniqueness: true, presence: true

  include Slug

  default_scope {order(:code)}
end
