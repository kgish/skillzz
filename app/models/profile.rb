class Profile < ActiveRecord::Base
  validates :name, presence: true, inclusion: { in: %w(root category skill tag), message: "%{value} is not a valid node type, must be one of: root, category, skill or tag" }
  validates :this_id, presence: true

  has_one :user

  acts_as_nested_set  :before_add     => :do_before_add,
                      :after_add      => :do_after_add,
                      :before_remove  => :do_before_remove,
                      :after_remove   => :do_after_remove

  private

    def do_before_add(child_node)
      #puts "Profile.do_before_add"
    end

    def do_after_add(child_node)
      #puts "Profile.do_after_add"
    end

    def do_before_remove(child_node)
      #puts "Profile.do_before_remove"
    end

    def do_after_remove(child_node)
      #puts "Profile.do_after_remove"
    end
end
