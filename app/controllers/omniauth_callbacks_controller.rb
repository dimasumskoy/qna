class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_oauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success) if is_navigational_format?
    end
  end

  def twitter
    redirect_to email_path unless auth_params.info[:email]
  end

  private

  def auth_params
    request.env['omniauth.auth']
  end
end