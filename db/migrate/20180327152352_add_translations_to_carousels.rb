class AddTranslationsToCarousels < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        Carousel.create_translation_table! :title => :string, :description => :text, :slug => :string
      end

      dir.down do
        Carousel.drop_translation_table!
      end
    end
  end
end
