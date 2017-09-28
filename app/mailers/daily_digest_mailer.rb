class DailyDigestMailer < ApplicationMailer
  default from: 'test@qna.com'

  def digest(user)
    @questions = Question.daily_questions

    mail to: user.email
  end
end
