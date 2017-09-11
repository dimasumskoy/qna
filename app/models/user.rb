class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :twitter]

  has_many :questions
  has_many :answers
  has_many :votes, as: :votable
  has_many :comments
  has_many :authorizations

  def self.find_oauth(session)
    authorization = Authorization.where(provider: session[:provider], uid: session[:uid].to_s).first
    return authorization.user if authorization

    email = session[:email]
    user = User.where(email: email).first

    if user
      user.authorizations.create(provider: session[:provider], uid: session[:uid])
      user.confirmed? ? user.skip_confirmation! : user.send_confirmation_instructions
    else
      password = Devise.friendly_token[0, 10]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create(provider: session[:provider], uid: session[:uid])
      user.send_confirmation_instructions
    end

    user
  end

  def author_of?(resource)
    id == resource.user_id
  end
end
