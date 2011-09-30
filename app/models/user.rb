class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :username, :email, :password, :password_confirmation, :centre_id

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :on => :create
  validates_presence_of :username
  validates_uniqueness_of :email
  validates_uniqueness_of :username

  belongs_to :centre
  has_many :dossiers

  delegate :name, :to => :centre, :prefix => true

  def admin?
    role == "admin"
  end
end
