class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  after_create :send_notification

  scope :ordered, -> { order(best: :desc) }

  def best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  private

  def send_notification
    NewAnswerNotificationJob.perform_later(self.question)
  end
end
