class NotificationMailer < ApplicationMailer
  default from: 'test@qna.com'

  def new_answer(user, question)
    @question = question
    @user = user

    mail to: user.email
  end
end
