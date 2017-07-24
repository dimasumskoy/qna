class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :ordered, -> { order(best: :desc) }

  def best!
    question.answers.update_all(best: false)
    update!(best: true)
  end
end
