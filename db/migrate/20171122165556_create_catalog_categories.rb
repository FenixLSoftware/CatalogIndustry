class CreateCatalogCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :catalog_categories do |t|
      t.integer :catalog_id, index: true
      t.integer :category_id, index: true

      t.timestamps
    end
  end
end
