class AddBioToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bio, :text, default: '.', null: false
  end
end
