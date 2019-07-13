class AddFieldsToPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :next_payment, :datetime
    add_column :payments, :card_info, :string
  end
end
