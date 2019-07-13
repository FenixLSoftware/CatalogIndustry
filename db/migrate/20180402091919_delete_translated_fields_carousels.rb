class DeleteTranslatedFieldsCarousels < ActiveRecord::Migration[5.0]
  def change
  	remove_column :carousels, :title
    remove_column :carousels, :description
    remove_column :carousels, :slug
  end
end
