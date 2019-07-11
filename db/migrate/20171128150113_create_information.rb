class CreateInformation < ActiveRecord::Migration[5.0]
  def change
    create_table :information do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :city
      t.string :country
      t.string :company
      t.text :comment

      t.timestamps
    end
  end
end
