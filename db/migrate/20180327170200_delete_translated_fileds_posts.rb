class DeleteTranslatedFiledsPosts < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :title
    remove_column :posts, :description
    remove_column :posts, :slug
  end
end
