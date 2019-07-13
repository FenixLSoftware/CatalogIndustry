class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches do |t|
      t.string :term
      t.string :item_type

      t.timestamps
    end
  end
end
