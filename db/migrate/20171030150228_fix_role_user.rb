class FixRoleUser < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :role, :integer
  end
end
