class User < ActiveRecord::Base
  validates :fullname, presence: true, allow_blank: false
  validates :username, presence: true, allow_blank: false, uniqueness: { case_sensitive: false }
  validates :bio, presence: true, allow_blank: false

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  has_many :roles
  belongs_to :profile

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :excluding_archived, lambda { where(archived_at: nil) }

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
