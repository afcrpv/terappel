class Motif < ActiveRecord::Base
  attr_accessible :name, :oldid

  has_many :dossiers

  default_scope order(:name)

  def code
    name[0..1] if name.present?
  end
end
