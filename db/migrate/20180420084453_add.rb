class Add < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :user_company_name, :string
  end
end
