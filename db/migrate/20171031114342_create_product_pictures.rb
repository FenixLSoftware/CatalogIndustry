class CreateProductPictures < ActiveRecord::Migration[5.0]
  def change
    create_table :product_pictures do |t|
      t.string :picture
      t.integer :product_id
      t.integer :order

      t.timestamps
    end
  end
end
