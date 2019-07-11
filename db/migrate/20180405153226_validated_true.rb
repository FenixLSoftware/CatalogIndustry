class ValidatedTrue < ActiveRecord::Migration[5.0]
  def change
    User.update_all(validated: true)
    User.reindex
    Catalog.update_all(validated: true)
    Catalog.reindex
    Product.update_all(validated: true)
    Product.reindex
    Post.update_all(validated: true)
    Post.reindex
  end
end
