class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(user, question)
    NotificationMailer.new_answer(user, question).deliver_now
  end
end
