class Skill < ActiveRecord::Base
  belongs_to :category
  belongs_to :author, class_name: "User"
  has_and_belongs_to_many :tags, uniq: true

  # The 'tag_names' attribute is a 'virtual' attribute with setter/getter methods, not actually present in the database.
  attr_accessor :tag_names

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true, length: { minimum: 10 }

  searcher do
    label :tag, from: :tags, field: "name"
  end

  def tag_names=(names)
    @tag_names = names
    # Split tag name list over spaces.
    names.split.each do |name|
      # Reuse existing tags or create if not already present.
      self.tags << Tag.find_or_initialize_by(name: name)
    end
  end
end
