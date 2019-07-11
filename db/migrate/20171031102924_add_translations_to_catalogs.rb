class AddTranslationsToCatalogs < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        Catalog.create_translation_table! :name => :string, :description => :text, :keywords => :string
      end

      dir.down do
        Catalog.drop_translation_table!
      end
    end
  end
end
