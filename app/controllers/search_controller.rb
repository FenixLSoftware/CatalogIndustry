class SearchController < ApplicationController

  def save_search
    if current_user.present?
      if params[:term].present?
        current_user.save_search(params[:term])
      end
    end
    gflash :success => t('m.saved_search')
    redirect_to search_get_path(term: params[:term])
  end



  def search
    search = params[:term].present? ? params[:term] : nil

    @term = search

    if search
      if params[:p].present?
        arr = [] #p c e n
        #[User, Catalog, Product, Post]
        if params[:p]='p' #productos
          arr << Product
        end
        if params[:p]='c' #catalogos
          arr << Catalog
        end
        if params[:p]='e' #empresas
          arr << User
        end
        if params[:p]='n' #noticias
          arr << Post
        end
        @search = Searchkick.search search, index_name: arr, page: params[:page], per_page: 8
        render 'search2'
      else
      #grabamos la busqueda asociada al usuario

        #if current_user.present?
        #  current_user.save_search(search)
        #end

        @products = Product.search search, where: {published: true, validated: true}, limit: 10
        @catalogs = Catalog.search search, where: {published: true, validated: true}, limit: 10
        @categories = Category.search search, where: {is_root: false}, limit: 6
        @companies = User.search search, where: {validated: true, role: 'role_company'}, limit: 16
        @posts = Post.search search, where: {published: true, validated: true}, limit: 20

        render 'search'
      end
     else
       redirect_to root_path
     end

  end

  def search2
    search = params[:term].present? ? params[:term] : nil
    arr = [] #p c e n
    #[User, Catalog, Product, Post]
    if params[:p]='p' #productos
      arr << Product
    end
    if params[:p]='c' #catalogos
      arr << Catalog
    end
    if params[:p]='e' #empresas
      arr << User
    end
    if params[:p]='n' #noticias
      arr << Post
    end
    @search = Searchkick.search search, index_name: arr, page: params[:page], per_page: 8
  end
end
