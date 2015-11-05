class Category < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  # Cull all the associated skills when a given category is destroyed
  has_many :skills, dependent: :delete_all

  has_many :roles, dependent: :delete_all
end
