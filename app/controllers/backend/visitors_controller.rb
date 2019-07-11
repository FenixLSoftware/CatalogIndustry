class Backend::VisitorsController < Backend::AdminController

  before_action :set_visitor, only: [:show]

  def index

    @title = "Visitantes identificados"

    @visits = Impression.where.not(user_id: [nil,current_user.id]).where(message: current_user.id.to_s).order(created_at: :desc).paginate(:page => params[:page], :per_page => 20)

  end

  def show
    unless @visit.company_id == current_user.id
      redirect_to backend_informations_path
    end
    @title = "Visita identificada "# + @information.name.to_s
  end



  private

  def set_visit
    @visit = Visit.find(params[:id])

  end
end
