class AddvalidatedToObjects < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :validated, :boolean, default: false
    add_column :posts, :validated, :boolean, default: false
    add_column :products, :validated, :boolean, default: false
    add_column :catalogs, :validated, :boolean, default: false

  end
end
