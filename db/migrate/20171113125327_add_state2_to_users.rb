class AddState2ToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :state, :string
  end
end
