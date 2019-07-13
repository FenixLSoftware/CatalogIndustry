class FixDescriptionTranslationsUsers < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        User.drop_translation_table!
        User.create_translation_table! :description => :text
      end

      dir.down do
        #Product.drop_translation_table!
      end
    end
  end
end
