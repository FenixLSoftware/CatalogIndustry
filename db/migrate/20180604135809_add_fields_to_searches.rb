class AddFieldsToSearches < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :products, :text
    add_column :searches, :catalogs, :text
    add_column :searches, :companies, :text
    add_column :searches, :posts, :text
  end
end
