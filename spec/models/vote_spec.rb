require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:votable) }
  it { should validate_inclusion_of(:votable_type).in_array(%w(Question Answer)) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:votable_id, :votable_type) }

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:positive_vote) { create(:vote, user_id: user.id, votable: question) }
  let!(:negative_vote) { create(:negative_vote, user_id: another_user, votable: question) }

  context 'scopes' do
    it '.count_positive' do
      expect(question.votes.count_positive).to eq 1
    end

    it '.count_negative' do
      expect(question.votes.count_negative).to eq 1
    end

    it '.count_rating' do
      expect(question.votes.count_rating).to eq 0
    end
  end
end