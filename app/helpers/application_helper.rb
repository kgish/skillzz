module ApplicationHelper
  def title(*parts)
    unless parts.empty?
      content_for :title do
        (parts << 'SkillZZ').join(' - ')
      end
    end
  end

  def admins_only(&block)
    block.call if current_user.try(:admin?)
  end

  def workers_only(&block)
    block.call if current_user.try(:worker?)
  end

  def customers_only(&block)
    block.call if current_user.try(:customer?)
  end

end
