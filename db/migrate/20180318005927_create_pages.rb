class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.integer :catalog_id
      t.integer :page_number
      t.string :language
      t.string :page

      t.timestamps
    end
  end
end
