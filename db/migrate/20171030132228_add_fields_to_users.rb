class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_name, :string, default: ''
    add_column :users, :role, :string, default: ''
    add_column :users, :company_name, :string, default: ''
    add_column :users, :vat, :string, default: ''
    add_column :users, :address, :string, default: ''
    add_column :users, :postal, :string, default: ''
    add_column :users, :city, :string, default: ''
    add_column :users, :country, :string, default: ''
    add_column :users, :phone, :string, default: ''
    add_column :users, :website, :string, default: ''
    add_column :users, :description, :text
    add_column :users, :logo, :string
    add_column :users, :company_picture, :string
    add_column :users, :current_plan, :integer, default: 0
  end
end
