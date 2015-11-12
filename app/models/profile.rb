class Profile < ActiveRecord::Base
  validates :name, presence: true, inclusion: { in: %w(root category skill tag), message: "%{value} is not a valid node type, must be one of: root, category, skill or tag" }
  validates :this_id, presence: true

  has_one :user

  acts_as_nested_set  :before_add     => :do_before_add,
                      :after_add      => :do_after_add,
                      :before_remove  => :do_before_remove,
                      :after_remove   => :do_after_remove

  def flatten
    # TODO: This should only be cached as long as not dirty!
    # Good enough now for demo purposes.
    @flattened || @flattened = flatten_me
  end

  def flatten_me
    graphs = []
    graphs_1 = []
    graphs_2 = []
    graphs_3 = []
    self.children.each do |category|
      graphs_1.push([category.this_id])
      category.children.each do |skill|
        graphs_2.push([category.this_id, skill.this_id])
        skill.children.each do |tag|
          graphs_3.push([category.this_id, skill.this_id, tag.this_id])
        end
      end
    end
    graphs.push(graphs_1)
    graphs.push(graphs_2)
    graphs.push(graphs_3)
    graphs.to_json
  end

  private

    # TODO: Maybe useful?
    # def do_before_add(child_node)
    #   #puts "Profile.do_before_add"
    # end
    #
    # def do_after_add(child_node)
    #   #puts "Profile.do_after_add"
    # end
    #
    # def do_before_remove(child_node)
    #   #puts "Profile.do_before_remove"
    # end
    #
    # def do_after_remove(child_node)
    #   #puts "Profile.do_after_remove"
    # end
end
