class AddTranslationsToProducts < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        Product.create_translation_table! :name => :string, :description => :text, :keywords => :string
      end

      dir.down do
        Product.drop_translation_table!
      end
    end
  end
end
