require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_list(:user, 2) }
  let(:questions) { create_list(:question, 2) }

  it 'should send digest to every user' do
    users.each do |user|
      expect(DailyDigestMailer).to receive(:digest).and_call_original
      DailyDigestMailer.digest(user, questions)
    end
  end
end
