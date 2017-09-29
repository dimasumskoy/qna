require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_list(:user, 2) }

  it 'should send digest to every user' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original }
    DailyDigestJob.perform_now
  end
end
