class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user

  scope :daily_questions, -> { where(created_at: (Time.now - 1.day)..Time.now) }

  validates :title, :body, presence: true
end