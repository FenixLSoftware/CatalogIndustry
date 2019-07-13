class AddTranslationsToSlugs < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        Catalog.add_translation_fields! slug: :string
        Product.add_translation_fields! slug: :string
      end

      dir.down do
        remove_column :catalog_translations, :slug
        remove_column :product_translations, :slug
      end
    end
  end
end
