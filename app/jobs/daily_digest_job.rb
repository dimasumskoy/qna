class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    questions ||= Question.daily_questions

    User.find_each do |user|
      DailyDigestMailer.digest(user, questions).deliver_now
    end
  end
end
