class DailyDigestMailer < ApplicationMailer
  default from: 'test@qna.com'

  def digest(user)
    @questions

    mail to: user.email
  end
end
