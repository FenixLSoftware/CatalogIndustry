class Backend::SearchesController < Backend::AdminController

  before_action :set_search, only: [:show]

  def index

  @title = "Tus búsquedas recientes"

  @searches = Search.where(user: current_user).order(created_at: :desc).paginate(:page => params[:page], :per_page => 20)
  end

  def destroy
    if Search.find(params['id']).user == current_user
      Search.find(params['id']).destroy
      gflash success: 'Busqueda eliminada.'
    else
      gflash error: 'Busqueda no eliminada.'
    end
    redirect_to backend_searches_path

  end

  def show
    unless @visit.company_id == current_user.id
      redirect_to backend_informations_path
    end
    @title = "Visita identificada "# + @information.name.to_s
  end



  private

  def set_search
    @visit = Visit.find(params[:id])

  end
end
