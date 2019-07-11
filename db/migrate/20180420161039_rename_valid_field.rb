class RenameValidField < ActiveRecord::Migration[5.0]
  def change
    rename_column :payments, :valid, :success
  end
end
