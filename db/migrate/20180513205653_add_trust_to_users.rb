class AddTrustToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :trust, :boolean, default: false
  end
end
