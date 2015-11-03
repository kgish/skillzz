class Skill < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true, length: { minimum: 10 }
end
