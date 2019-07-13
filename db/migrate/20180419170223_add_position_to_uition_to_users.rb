class AddPositionToUitionToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :position, :string
    add_column :users, :extra_picture, :string
  end
end
