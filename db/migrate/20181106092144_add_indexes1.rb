class AddIndexes1 < ActiveRecord::Migration[5.0]
  def change
    add_index :posts, :published
    add_index :posts, :validated

    add_index :users, :validated
    add_index :users, :role

    add_index :catalogs, :published
    add_index :catalogs, :validated
  end
end
