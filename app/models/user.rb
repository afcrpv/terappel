class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  attr_accessible :centre_id, :role, :as => :admin

  validates_confirmation_of :password
  validates_presence_of :email, :on => :create
  validates_presence_of :username
  validates_uniqueness_of :email
  validates_uniqueness_of :username

  belongs_to :centre
  has_many :dossiers

  delegate :name, :to => :centre, :prefix => true, :allow_nil => true

  def admin?
    role == "admin"
  end
end
