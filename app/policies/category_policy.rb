class CategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    # Just in case, the call to 'user.try' will return nil even if user is undefined
    user.try(:admin?) || record.roles.exists?(user_id: user)
  end

end
