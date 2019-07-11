class Search < ApplicationRecord

  belongs_to :user

  private

  def self.refresh_searches
    Search.all.each do |s|
      #buscamos que existe el usuario
      user_search = nil
      user_search = s.user if s.user.present?
      if user_search
        #ejecutamos la busqueda de nuevo
        @products = Product.search s.term, where: {published: true, validated: true}
        @catalogs = Catalog.search s.term, where: {published: true, validated: true}
        @categories = Category.search s.term, where: {is_root: false}
        @posts = Post.search s.term, where: {published: true, validated: true}
        s.products = @products.map(&:id).join(',')
        s.catalogs = @catalogs.map(&:id).join(',')
        s.posts = @posts.map(&:id).join(',')
        if s.changed?
          # algo ha cambiado
          s.save
          #mandar mail al usuario
          ApplicationMailer.search_update(s.user, s).deliver
        end
      end
    end
  end
end
