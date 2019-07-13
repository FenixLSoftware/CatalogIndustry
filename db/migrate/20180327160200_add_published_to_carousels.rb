class AddPublishedToCarousels < ActiveRecord::Migration[5.0]
  def change
  	 add_column :carousels, :published, :boolean, default: true
  end
end
