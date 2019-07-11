class DeletFieldsTrasnlatedCategories < ActiveRecord::Migration[5.0]
  def change
    remove_column :products, :name
    remove_column :products, :description
    remove_column :products, :keywords
    remove_column :products, :slug

  end
end
