class Backend::InformationsController < Backend::AdminController

  before_action :set_information, only: [:show, :destroy]

  def index

  @title = "Solicitudes de informacion"

  @informations = Information.where(user: current_user).order(created_at: :desc).paginate(:page => params[:page], :per_page => 20)
  end

  def show
    if @information.user == current_user

    else
      redirect_to backend_informations_path
    end
    @title = "Petición de informacion de " + @information.name.to_s

  end


  def destroy
    @information.destroy
    gflash success: t('m.removed_info')
    redirect_to backend_informations_path

  end

  private

  def set_information
    @information = Information.find(params[:id])

  end
end
