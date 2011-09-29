class Dossier < ActiveRecord::Base
  validates_presence_of :name, :date_appel
end
