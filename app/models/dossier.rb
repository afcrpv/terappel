class Dossier < ActiveRecord::Base
  #accessible attributes
  attr_accessible :name, :date_appel, :centre_id, :user_id, :code

  extend FriendlyId
  friendly_id :code

  # validations
  validates_presence_of :name, :date_appel, :centre_id, :user_id
  #TODO: add more required field

  #associations
  belongs_to :centre
  belongs_to :user

  #delegations
  delegate :name, :code, :to => :centre, :prefix => true
  delegate :username, :to => :user, :allow_nil => true
end
