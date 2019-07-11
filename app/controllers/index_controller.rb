class IndexController < ApplicationController

  layout 'frontend/home'
  def index


    @catalogs = Catalog.includes(:translations).visible_front.order(created_at: :desc)[0..11]
    @products = Product.includes(:translations).visible_front.order(created_at: :desc)[0..3]
    @companies = User.includes(:translations).visible_front.role_company.order(created_at: :desc)[0..5]
    @categories = Category.includes(:translations).roots.sort {|a,b| a.name <=> b.name}
    @posts = Post.visible_front.includes(:translations).order(created_at: :desc)[0..3]
  end
end
