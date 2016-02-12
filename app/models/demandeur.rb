class Demandeur < ActiveRecord::Base
  belongs_to :dossier
  belongs_to :correspondant

  delegate :to_s, to: :correspondant
end
