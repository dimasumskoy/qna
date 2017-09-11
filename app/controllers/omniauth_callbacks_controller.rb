class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_oauth, only: [:facebook, :twitter]

  def facebook
    authenticate_user(@auth)
  end

  def twitter
    authenticate_user(@auth)
  end

  def set_email
    if params[:email].present?
      session[:email] = params[:email]
      authenticate(session)
    else
      render template: 'users/email'
    end
  end

  private

  def set_oauth
    @auth = request.env['omniauth.auth']
  end

  def authenticate_user(auth)
    session[:uid] = auth.uid
    session[:provider] = auth.provider
    session[:email] = auth.info[:email]

    if session[:email].blank?
      render template: 'users/email'
    else
      authenticate(session)
    end
  end

  def authenticate(session)
    @user = User.find_oauth(session)

    if @user && @user.persisted? && @user.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: session[:provider]) if is_navigational_format?
    end
  end
end