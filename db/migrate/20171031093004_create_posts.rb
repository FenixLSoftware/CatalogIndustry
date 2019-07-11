class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :picture
      t.boolean :published, default: true
      t.text :description
      t.string :slug
      t.timestamps
    end
  end
end
