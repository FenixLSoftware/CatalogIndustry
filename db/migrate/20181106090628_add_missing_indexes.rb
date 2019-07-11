class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :catalogs, :user_id
    add_index :information, :user_id
    add_index :pages, :catalog_id
    add_index :payments, :user_id
    add_index :posts, :user_id
    add_index :product_pictures, :product_id
    add_index :products, :user_id
    add_index :searches, :user_id
  end
end
