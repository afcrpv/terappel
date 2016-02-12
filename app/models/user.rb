class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :lockable, :recoverable, :registerable,
         :rememberable, :trackable, :validatable

  belongs_to :centre

  validates :email, presence: true, uniqueness: true
  validates :centre_id, presence: true

  delegate :name, to: :centre, prefix: true, allow_nil: true

  def active_for_authentication?
    super && (approved? || admin?)
  end

  def admin?
    has_role? :admin
  end

  def approve!
    update_attribute(:approved, true)
  end

  def inactive_message
    if approved?
      super
    else
      :not_approved
    end
  end

  def to_s
    email
  end

  def self.send_reset_password_instructions(attributes = {})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t('devise.failure.not_approved')
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

end
