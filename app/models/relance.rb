class Relance < ActiveRecord::Base
  belongs_to :dossier
  belongs_to :correspondant
end
