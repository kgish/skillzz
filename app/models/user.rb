class User < ActiveRecord::Base

  VALID_USER_REGEX = /\A[a-z0-9_\.]+\z/i
  validates :username, presence: true, format: { with: VALID_USER_REGEX }, uniqueness: { case_sensitive: false }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  validates :fullname, presence: true, allow_blank: false

  has_many :roles
  belongs_to :profile

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  scope :excluding_archived, lambda { where(archived_at: nil) }

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

  def to_s
    "#{email} (#{admin? ? "Admin" : "User"})"
  end

  def archive
    self.update(archived_at: Time.now)
  end

  # Tell devise to disallow login if the user is archived.
  def active_for_authentication?
    super && archived_at.nil?
  end

  # See config/locales/devise.en.yml => en.devise.failure.user.archived
  def inactive_message
    archived_at.nil? ? super : :archived
    end

  def role_on(category)
    roles.find_by(category_id: category).try(:name)
  end

end
