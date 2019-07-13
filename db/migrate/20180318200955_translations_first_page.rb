class TranslationsFirstPage < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        Catalog.add_translation_fields! first_page_picture: :string
      end

      dir.down do
        remove_column :catalog_translations, :first_page_picture
      end
    end
    remove_column :catalogs, :first_page_picture
  end
end
