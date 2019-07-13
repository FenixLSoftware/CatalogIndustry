class AddIndex2 < ActiveRecord::Migration[5.0]
  def change
    add_index :catalogs, :created_at
  end
end
