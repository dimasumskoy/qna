require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:votable) { create(model.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  context 'voting' do
    it '#vote_up' do
      votable.vote_up(user)
      expect(votable.votes.size).to eq 1
      expect(votable.votes.count_positive).to eq 1
    end

    it '#vote_down' do
      votable.vote_down(user)
      expect(votable.votes.size).to eq 1
      expect(votable.votes.count_negative).to eq 1
    end

    it '#revote' do
      votable.vote_up(user)
      votable.revote(user)
      votable.reload.votes.each do |vote|
        expect(vote.user_id).to_not eq user.id
      end
    end
  end

  context '#voted?' do
    let(:other_user) { create(:user) }

    it 'returns true' do
      votable.vote_up(user)
      expect(votable.voted?(user)).to be_truthy
    end

    it 'returns false' do
      expect(votable.voted?(other_user)).to be_falsey
    end
  end
end