require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'Attachments validatable'
  it_behaves_like 'Votes validatable'
  it_behaves_like 'Votable'

  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:subscriptions).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:subscription) { create(:subscription, question: question, user: user) }

  describe '.daily_questions' do
    let!(:old_question) { create(:question, created_at: 2.days.ago) }
    let!(:new_question) { create(:question, created_at: Time.now) }

    it 'should return question for the last 1 day' do
      expect(Question.daily_questions.last).to eq new_question
    end

    it 'should not return question older than 1 day' do
      expect(Question.daily_questions).to_not contain_exactly(old_question)
    end
  end

  describe '#subscribe' do
    it 'should create new subscription for question' do
      expect(question.subscriptions.count).to eq 1
    end

    it 'should create new subscription for user' do
      expect(user.subscriptions.count).to eq 1
    end
  end

  describe '#unsubscribe' do
    before { question.unsubscribe(user) }

    it 'should delete subscription from question' do
      expect(question.reload.subscriptions.count).to eq 0
    end

    it 'should delete subscription from user' do
      expect(user.reload.subscriptions.count).to eq 0
    end
  end
end