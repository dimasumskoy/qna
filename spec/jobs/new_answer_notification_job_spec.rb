require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:subscription) { create(:subscription, question: question, user: user) }

  it 'should send notification to user' do
    expect(NotificationMailer).to receive(:new_answer).with(user, question).and_call_original
    NewAnswerNotificationJob.perform_now(question)
  end
end
