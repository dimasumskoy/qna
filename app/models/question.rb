class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions

  belongs_to :user

  validates :title, :body, presence: true

  scope :daily_questions, -> { where(created_at: (Time.now - 1.day)..Time.now) }
end