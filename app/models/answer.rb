class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :ordered, -> { order(best: :desc) }

  def best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
