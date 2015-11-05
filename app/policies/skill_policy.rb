class SkillPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    user.try(:admin?) || record.category.has_member?(user)
  end

  def create?
    user.try(:admin?) || record.category.has_manager?(user) || record.category.has_editor?(user)
  end

end
