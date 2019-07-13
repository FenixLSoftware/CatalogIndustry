class CreateCarousels < ActiveRecord::Migration[5.0]
  def change
    create_table :carousels do |t|
      t.string :title
      t.string :picture
      t.text :description
      t.string :slug
      t.timestamps
    end
  end
end
