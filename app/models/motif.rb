class Motif < ActiveRecord::Base
  has_many :dossiers

  default_scope {order(:name)}

  def code
    name[0..1] if name.present?
  end
end
