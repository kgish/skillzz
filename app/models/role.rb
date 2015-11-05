class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  def self.available_roles
    %w(manager editor viewer)
  end
end
