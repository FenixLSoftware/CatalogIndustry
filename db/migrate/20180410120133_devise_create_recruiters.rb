class DeviseCreateRecruiters < ActiveRecord::Migration[5.0]
  def change
      # LinkedIn
      add_column :users, :provider, :string
      add_column :users, :uid, :string, unique: true
  end
end
