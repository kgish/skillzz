class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.integer :this_id

      t.integer :parent_id
      t.integer :lft
      t.integer :rgt

      # optional fields
      t.integer :depth, default: 0
      t.integer :children_count, default: 0

    end
    add_index :profiles, [:parent_id, :lft, :rgt, :depth]
  end
end
