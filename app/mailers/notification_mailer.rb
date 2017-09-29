class NotificationMailer < ApplicationMailer
  default from: 'test@qna.com'

  def new_answer(user, question)
    @question = question

    mail to: user.email
  end
end
