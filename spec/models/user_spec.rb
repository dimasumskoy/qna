require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }
  let(:user_question) { create(:question, user: user) }
  let(:not_user_question) { create(:question) }

  describe '#author_of?' do
    it 'returns true' do
      expect(user).to be_author_of(user_question)
    end

    it 'returns false' do
      expect(user).to_not be_author_of(not_user_question)
    end
  end

  describe '.find_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization'
    context 'user does not exist'
  end
end
