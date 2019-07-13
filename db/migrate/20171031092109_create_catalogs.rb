class CreateCatalogs < ActiveRecord::Migration[5.0]
  def change
    create_table :catalogs do |t|
      t.string :name
      t.text :description
      t.string :keywords
      t.boolean :published, default: true
      t.string :first_page_picture
      t.string :pdf
      t.integer :user_id
      t.string :slug
      t.timestamps
    end
  end
end
