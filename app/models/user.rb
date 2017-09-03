class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  has_many :questions
  has_many :answers
  has_many :votes, as: :votable
  has_many :comments

  def author_of?(resource)
    id == resource.user_id
  end
end
