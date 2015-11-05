class CategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none if user.nil?
      return scope.all if user.admin?

      scope.joins(:roles).where(roles: {user_id: user})
    end
  end

  def show?
    # Just in case, the call to 'user.try' will return nil even if user is undefined
    user.try(:admin?) || record.roles.exists?(user_id: user)
  end

  def update?
    user.try(:admin?) || record.roles.exists?(user_id: user, role: 'manager')
  end
end
