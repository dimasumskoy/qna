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
    let(:question) { create(:question) }
    let(:user_question) { create(:question, user: user) }

    let(:answer) { create(:answer) }
    let(:user_answer) { create(:answer, user: user) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

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
  end
end