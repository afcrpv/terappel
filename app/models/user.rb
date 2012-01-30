class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :current_password, :password, :password_confirmation, :remember_me, :centre_id

  attr_writer :current_password

  ROLES = %w(centre_user centre_admin admin )

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  validates_presence_of :email, :on => :create
  validates_presence_of :username
  validates_uniqueness_of :email
  validates_uniqueness_of :username
  validates_confirmation_of :password

  belongs_to :centre
  has_many :dossiers

  delegate :name, :to => :centre, :prefix => true, :allow_nil => true

  def admin?
    role == "admin"
  end
end
