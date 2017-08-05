require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should validate_inclusion_of(:votable_type).in_array(%w(Question Answer)) }

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:positive_votes) { create_list(:vote, 2, value: 1, user_id: user.id, votable: question) }
  let!(:negative_votes) { create_list(:vote, 2, value: -1, user_id: user.id, votable: question) }

  context 'scopes' do
    it '.count_positive' do
      expect(question.votes.count_positive).to eq 2
    end

    it '.count_negative' do
      expect(question.votes.count_negative).to eq 2
    end

    it '.count_rating' do
      expect(question.votes.count_rating).to eq 0
    end
  end
end
