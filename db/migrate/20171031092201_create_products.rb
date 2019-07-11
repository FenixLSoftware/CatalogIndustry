class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :keywords
      t.boolean :published, default: true
      t.integer :user_id
      t.string :slug

      t.timestamps
    end
  end
end
