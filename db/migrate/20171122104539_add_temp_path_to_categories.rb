class AddTempPathToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :temp_path, :integer
  end
end
