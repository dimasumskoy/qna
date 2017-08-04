require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:positive_votes) { create_list(:vote, 2, value: 1, user_id: user, votable: question) }
  let!(:negative_votes) { create_list(:vote, 2, value: -1, user_id: user, votable: question) }

  context '.positive' do
    it 'counts positive votes'
  end
end
