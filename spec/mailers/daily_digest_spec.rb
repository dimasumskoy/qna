require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe '#digest' do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Digest')
      expect(mail.to).to eq(['user1@test.com'])
      expect(mail.from).to eq (['test@qna.com'])
    end
  end
end
