class AddFieldsAndIndexToVisits < ActiveRecord::Migration[5.0]
  def change
    add_index :visits, :user_id
    add_index :visits, :element_id
    add_index :visits, :element_type
    add_index :visits, :company_id
    add_column :visits, :anonymous, :boolean
  end
end
