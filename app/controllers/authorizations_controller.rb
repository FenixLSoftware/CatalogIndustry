class AuthorizationsController < Devise::OmniauthCallbacksController
  def linkedin
    @user = User.from_omniauth(request.env['omniauth.auth'])

    sign_in_and_redirect @user, event: :authentication
  end

  def failure
    redirect_to root_path
  end
end