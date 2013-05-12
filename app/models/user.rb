class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %w(centre_user centre_admin admin)

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  belongs_to :centre

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :centre_id, presence: true

  delegate :name, :to => :centre, :prefix => true, :allow_nil => true

  def admin?
    role == "admin"
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  def approve!
    self.update_attribute(:approved, true)
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end
end
