module AuthorizationHelpers
  def assign_role!(user, role, category)
    Role.where(user: user, category: category).delete_all
    Role.create!(user: user, role: role, category: category)
  end
end

RSpec.configure do |c|
  c.include AuthorizationHelpers
end