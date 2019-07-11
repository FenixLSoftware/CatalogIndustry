class Backend::UsersController < Backend::AdminController
  before_action :set_user, only: [:card_info, :show, :edit, :update, :set_user, :switch_plan, :payments]
  before_action :check_valid_user

  def card_info

  end
  def index
    if current_user.role_admin?
      @title = "Usuarios registrados"
      #todos los usuarios que no tengan el rol de admin
      if params[:search].present?
        @title = @title + ' conteniendo ' + params[:search].to_s
        search = params['search']
        @users_all = User.search search ,misspellings: {below: 2}, where: {role: 'role_professional' }, page: params[:page], per_page: 20
      else
        search = '*'
        @users_all = User.search search ,misspellings: {below: 2}, where: {role: 'role_professional' }, order: { created_at: :desc}, page: params[:page], per_page: 20
      end


    else
      redirect_to root_path
    end
  end

  def index_companies
    if current_user.role_admin?
      @title = "Empresas registrados"
      #todos los usuarios que no tengan el rol de admin
      if params[:search].present?
        @title = @title + ' conteniendo ' + params[:search].to_s
        search = params['search']
        @users_all = User.search search ,misspellings: {below: 2}, where: {role: 'role_company' }, page: params[:page], per_page: 20

      else
        search = '*'
        @users_all = User.search search ,misspellings: {below: 2}, where: {role: 'role_company' }, order: { created_at: :desc}, page: params[:page], per_page: 20

      end

    else
      redirect_to root_path
    end
  end


  def show

    @title = "Usuarios identificados " # + @information.name.to_s
  end


  def switch_plan
    # si tengo pagado


    if @user.payment_valid
      if @user.current_plan == 0
        @user.current_plan = 1
        @user.save
        gflash success: t('m.plan_changed')
        redirect_to edit_backend_user_path(@user), anchor: 'card'
      else
        @user.current_plan = 0
        @user.save
        gflash success: t('m.plan_changed')
        redirect_to edit_backend_user_path(@user), anchor: 'card'
      end
    else
      if @user.current_plan == 0
        @user.current_plan = 1
        @user.save
        gflash success: t('m.plan_changed')
        redirect_to edit_backend_user_path(@user), anchor: 'card'
      else
        @user.current_plan = 0
        @user.save
        gflash success: t('m.plan_changed')
        redirect_to edit_backend_user_path(@user), anchor: 'card'
      end

    end



    # si no tengo pagado



  end

  def payments
    if current_user.role_admin?
      @payments = Payment.includes(:user).order(created_at: :desc).paginate(:page => params[:page], :per_page => 20)
    else
      @payments = Payment.includes(:user).where(user: @user).order(created_at: :desc).paginate(:page => params[:page], :per_page => 20)
    end
  end


  def all_payments
    if current_user.role_admin?
      @all_payments = Payment.includes(:user).order(created_at: :desc).paginate(:page => params[:page], :per_page => 20)
    else
      redirect_to root_path
    end
  end

  def update
    @title = "Editando: " + @user.name.to_s
    respond_to do |format|
      # v@user.categories = []
      # v@catalog.categories << Category.where(id: params[:categories])

      if params[:user][:website].present?
        # si no empieza por http o https, se lo meto.
        if params[:user][:website].start_with?('http://') || params[:user][:website].start_with?('https://')

        else
          params[:user][:website] = 'http://' + params[:user][:website]
        end
      end

      if @user.validated == false && params[:user][:validated] == 'true'
        ApplicationMailer.company_validated(@user).deliver
      end

      a = nil
      # ver si manda nueva tarjeta
      if params[:user][:card_number].present? && params[:user][:card_name].present? && params[:user][:card_month].present? &&  params[:user][:card_year].present? &&  params[:user][:card_cvv].present?
        a = @user.assign_card(params[:user][:card_number], params[:user][:card_month], params[:user][:card_year], params[:user][:card_cvv], params[:user][:card_name])
        # ver si debo cobrar el primer mes
        if a.class.name == 'Stripe::CardError'
          # hay error en la tarjeta
          @user.error_card = a.message
          @user.save
          gflash warning: t('m.error_in_card')
          redirect_to card_info_backend_user_path(@user)
          return
        else
          @user.error_card = ''
        end

          unless @user.payment_valid
            resp = @user.charge_amount(12098, 'eur', 'Fee CatalogIndustry.com')
            if resp[:status]
              # pago ok
              @user.current_plan = 1
              @user.save
              @user.reload
            else
              #pago con error
              @user.current_plan = 0
              @user.save
              @user.reload
            end

          end

      end
      # ver is quiere cambiar la password:
      if params[:user][:pw_a].present? && params[:user][:pw_n]

        if params[:user][:pw_a].size >= 8 && params[:user][:pw_n].size >= 8
          if @user.valid_password?(params[:user][:pw_a])
            @user.update_with_password(password: params[:user][:pw_n])
            @user.save
            sign_in(@user, :bypass => true)
            gflash success: t('m.password_changed')
            # redirect_to :back, notice: 'Password updated'
            # return
            #          redirect_to :back, notice: 'MCSC'
          else
            gflash error: t('m.password_not_changed')
          end
        else
          gflash error: t('m.password_8_chars')
        end
      end

      if @user.update_attributes(user_params)

        if @user.company_name.present?
          @user.role = :role_company
          @user.send_to_stripe unless @user.stripe_id.present?
          @user.slug = @user.company_name.parameterize
          @user.save
        end
        # format.html { redirect_to edit_backend_user_path(@user), notice: t('successfully_updated_record') }
        # format.json { render :show, status: :ok, location: @catalog }
      else
        # format.html { render :edit }
        # format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
      gflash success: t('m.updated_data')
      if a.present?
        format.html { redirect_to edit_backend_user_path(@user, anchor: 'card'), notice: t('successfully_updated_record') }
      else
        format.html { redirect_to edit_backend_user_path(@user), notice: t('successfully_updated_record') }
      end
    end
  end

  def search
    index
    render 'index'
  end

  private

  def user_params
    params.require(:user).permit(:logo, :card_name, :card_number, :card_month, :card_year, :card_cvv, :user_company_name, :position, :validated, :pw_a, :pw_n, :name, :vat, :address, :postal, :company_name, :city, :country, :phone, :website, :company_picture, :state,
                                 translations_attributes: [:id,
                                                          :locale,
                                                          :description])
  end

  def set_user
    @user = User.friendly.find(params[:id])
  end

  def check_valid_user
    if current_user.role_admin?

    else
      if current_user == @user

      else
        redirect_to root_path
      end
    end
  end
end
