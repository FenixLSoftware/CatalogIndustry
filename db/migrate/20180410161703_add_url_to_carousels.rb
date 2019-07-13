class AddUrlToCarousels < ActiveRecord::Migration[5.0]
  def change
  	    add_column :carousels, :url, :string
  end
end
