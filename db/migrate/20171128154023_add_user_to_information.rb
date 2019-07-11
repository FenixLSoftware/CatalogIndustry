class AddUserToInformation < ActiveRecord::Migration[5.0]
  def change
    add_column :information, :user_id, :integer
  end
end
