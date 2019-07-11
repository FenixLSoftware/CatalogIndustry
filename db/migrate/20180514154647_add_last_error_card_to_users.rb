class AddLastErrorCardToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :error_card, :string
  end
end
