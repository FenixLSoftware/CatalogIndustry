class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.boolean :valid
      t.text :response
      t.integer :amount

      t.timestamps
    end
  end
end
