class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  belongs_to :user

  validates :title, :body, presence: true

  scope :daily_questions, -> { where(created_at: (Time.now - 1.day)..Time.now) }

  def subscribe(user)
    subscriptions.create(user: user) if user
  end

  def unsubscribe(user)
    subscriptions.where(user: user).first.destroy if user
  end
end