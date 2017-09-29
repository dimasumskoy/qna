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
  has_many :authorizations, dependent: :destroy

  def self.find_oauth(session)
    transaction do
      authorization = Authorization.where(provider: session[:provider], uid: session[:uid].to_s).first
      return authorization.user if authorization

      email = session[:email]
      user = User.where(email: email).first

      if user
        user.set_authorization(session)
        user.confirmed? ? user.skip_confirmation! : user.send_confirmation_instructions
      else
        password = Devise.friendly_token[0, 10]
        user = User.create!(email: email, password: password, password_confirmation: password)
        user.set_authorization(session)
      end

      user
    end
  end

  def self.find_by_auth(uid, provider)
    joins(:authorizations).where(authorizations: { uid: uid, provider: provider }).first
  end

  def set_authorization(session)
    self.authorizations.create(provider: session[:provider], uid: session[:uid])
  end

  def author_of?(resource)
    id == resource.user_id
  end

  def new_answer_notification(question)
    NotificationMailer.new_answer(self, question)
  end
end
