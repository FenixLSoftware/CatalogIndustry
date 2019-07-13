class RemoveTranslatedColumndOnCatalogs < ActiveRecord::Migration[5.0]
  def change
    remove_column :catalogs, :name
    remove_column :catalogs, :description
    remove_column :catalogs, :keywords
    remove_column :catalogs, :slug

  end
end
