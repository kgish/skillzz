class Category < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  # Cull all the associated skills when a given category is destroyed
  has_many :skills, dependent: :delete_all

  has_many :roles, dependent: :delete_all

  # Is the given user a member of this model?
  def has_member?(user)
    roles.exists?(user_id: user)
  end

  # Define for each role a method 'has_<role>?(user)'
  [:manager, :editor, :viewer].each do |role|
    define_method "has_#{role}?" do |user|
      roles.exists?(user_id: user, role: role)
    end
  end

end
