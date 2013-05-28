class Demandeur < ActiveRecord::Base
  belongs_to :dossier
  belongs_to :correspondant
end
