class AddStripeFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :stripe_id, :string, :default => ''
    add_column :users, :stripe_card_id, :string, :default => ''
    add_column :users, :stripe_month, :string, :default => ''
    add_column :users, :stripe_year, :string, :default => ''
    add_column :users, :stripe_brand, :string, :default => ''
    add_column :users, :stripe_last4, :string, :default => ''
  end
end
