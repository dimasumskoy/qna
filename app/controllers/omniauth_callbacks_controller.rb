class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_oauth, only: [:facebook, :twitter]
  before_action -> { authenticate_user(@auth) }, only: [:facebook, :twitter]

  def facebook
  end

  def twitter
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

    session[:email].blank? ? check_user(session) : authenticate(session)
  end

  def authenticate(session)
    @user = User.find_oauth(session)

    if @user && @user.persisted? && @user.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: session[:provider]) if is_navigational_format?
    else
      redirect_to root_path
      set_flash_message(:notice, :failure,
        kind: session[:provider], reason: 'You need to confirm email') if is_navigational_format?
    end
  end

  def check_user(session)
    user = User.find_by_auth(session[:uid], session[:provider])
    user ? authenticate(session) : render('users/email')
  end
end