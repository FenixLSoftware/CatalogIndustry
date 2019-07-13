class AddTranslationsToCategory < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        Category.create_translation_table! :name => :string, :slug => :string
      end

      dir.down do
        Category.drop_translation_table!
      end
    end
  end
end
