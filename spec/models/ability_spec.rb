require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'user' do
    let(:user) { create(:user) }

    let(:question)      { create(:question) }
    let(:user_question) { create(:question, user: user) }

    let(:answer)      { create(:answer, question: user_question) }
    let(:user_answer) { create(:answer, user: user) }

    let!(:question_vote) { create(:vote, user_id: user.id, votable: question) }
    let!(:answer_vote)   { create(:vote, user_id: user.id, votable: answer) }

    context 'general abilities' do
      it { should be_able_to :read, :all }
      it { should_not be_able_to :manage, :all }
    end

    context 'create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end

    context 'update' do
      it { should be_able_to :update, user_question }
      it { should_not be_able_to :update, question }

      it { should be_able_to :update, user_answer }
      it { should_not be_able_to :update, answer }
    end

    context 'destroy' do
      it { should be_able_to :destroy, user_question }
      it { should_not be_able_to :destroy, question }

      it { should be_able_to :destroy, user_answer }
      it { should_not be_able_to :destroy, answer }
    end

    context '#best' do
      it { should be_able_to :best, answer }
      it { should_not be_able_to :best, user_answer }
    end

    context 'vote for question' do
      it { should be_able_to :vote_up, question }
      it { should_not be_able_to :vote_up, user_question }

      it { should be_able_to :vote_down, question }
      it { should_not be_able_to :vote_down, user_question }

      it { should be_able_to :revote, question.reload }
      it { should_not be_able_to :revote, user_question }
    end

    context 'vote for answer' do
      it { should be_able_to :vote_up, answer }
      it { should_not be_able_to :vote_up, user_answer }

      it { should be_able_to :vote_down, answer }
      it { should_not be_able_to :vote_down, user_answer }

      it { should be_able_to :revote, answer.reload }
      it { should_not be_able_to :revote, user_answer }
    end
  end
end