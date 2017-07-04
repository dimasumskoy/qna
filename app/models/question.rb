class Question < ApplicationRecord
  has_many :answers, foreign_key: :question_id

  validates :title, :body, presence: true
end
