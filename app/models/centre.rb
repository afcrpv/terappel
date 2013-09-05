class Centre < ActiveRecord::Base
  has_many :users
  has_many :dossiers
  has_many :correspondants
  validates :name, uniqueness: true, presence: true

  include Slug

  default_scope {order(:code)}

  def to_s
    name
  end
end
