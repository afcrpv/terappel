class Dossier < ActiveRecord::Base
  validates_presence_of :name, :date_appel
  belongs_to :centre
  belongs_to :user

  delegate :name, :to => :centre, :prefix => true
end
