class PdfFileTranslation < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        Catalog.add_translation_fields! pdf: :string
      end

      dir.down do
        remove_column :catalog_translations, :pdf
      end
    end
    remove_column :catalogs, :pdf
  end
end
