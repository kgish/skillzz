class Skill < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true, length: { minimum: 10 }

  # The 'tag_names' attribute is a 'virtual' attribute with setter/getter methods, not actually present in the database.
  attr_accessor :tag_names

  has_and_belongs_to_many :tags, uniq: true

  belongs_to :category
  belongs_to :author, class_name: "User"

  def tag_names=(names)
    @tag_names = names
    # Split tag name list over spaces.
    names.split.each do |name|
      # Reuse existing tags or create if not already present.
      self.tags << Tag.find_or_initialize_by(name: name)
    end
  end
end
