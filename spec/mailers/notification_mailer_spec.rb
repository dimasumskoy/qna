require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe '#new_answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:mail) { NotificationMailer.new_answer(user, question) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New answer')
      expect(mail.to).to eq(['user1@test.com'])
      expect(mail.from).to eq (['test@qna.com'])
    end
  end
end
