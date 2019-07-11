class ModeStripeFields < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :stripe_name_card, :string, :default => ''

  end
end
