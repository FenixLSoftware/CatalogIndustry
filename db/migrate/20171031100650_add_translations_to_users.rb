class AddTranslationsToUsers < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        User.create_translation_table! :description => :string
      end

      dir.down do
        User.drop_translation_table!
      end
    end
  end
end
