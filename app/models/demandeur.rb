class Demandeur < ActiveRecord::Base
  belongs_to :dossier
  belongs_to :correspondant

  def to_s
    correspondant.to_s
  end
end
