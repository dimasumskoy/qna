require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for :attachments }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  let(:question) { create(:question) }
  let(:user) { create(:user) }

  context 'voting' do
    it '#vote_up' do
      question.vote_up(user)
      expect(question.votes.size).to eq 1
      expect(question.votes.count_positive).to eq 1
    end

    it '#vote_down' do
      question.vote_down(user)
      expect(question.votes.size).to eq 1
      expect(question.votes.count_negative).to eq 1
    end

    it '#revote' do
      question.vote_up(user)
      question.revote(user)
      question.reload.votes.each do |vote|
        expect(vote.user_id).to_not eq user.id
      end
    end
  end

  context '#voted?' do
    let(:other_user) { create(:user) }

    it 'returns true' do
      question.vote_up(user)
      expect(question.voted?(user)).to be_truthy
    end

    it 'returns false' do
      expect(question.voted?(other_user)).to be_falsey
    end
  end
end
