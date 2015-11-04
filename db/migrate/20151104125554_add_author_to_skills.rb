class AddAuthorToSkills < ActiveRecord::Migration
  def change
    add_reference :skills, :author, index: true
    add_foreign_key :skills, :users, column: :author_id
  end
end
