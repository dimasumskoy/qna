require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:questions) { create_list(:question, 2) }

  it 'should send digest to every user' do
    User.all.each do |user|
      expect(DailyDigestMailer).to receive(:digest).with(user, questions).and_call_original
    end
    DailyDigestJob.perform_now
  end
end
