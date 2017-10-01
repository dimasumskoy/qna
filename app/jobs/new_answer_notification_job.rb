class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(question)
    question.subscribers.find_each do |subscriber|
      NotificationMailer.new_answer(subscriber, question).deliver_later(wait: 5.seconds)
    end
  end
end
