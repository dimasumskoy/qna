require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:subscriptions).dependent(:destroy) }

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

    context 'user exist with authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_oauth(auth)).to eq user
      end
    end

    context 'user exist without authorization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', email: user.email) }

      it 'does not create new user' do
        expect { User.find_oauth(auth) }.to_not change(User, :count)
      end

      it 'creates new authorization with provider & uid' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        authorization = user.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'creates authorization for user' do
        expect { User.find_oauth(auth) }.to change(user.authorizations, :count).by(1)
      end

      it 'returns the user' do
        expect(User.find_oauth(auth)).to eq user
      end
    end

    context 'user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', email: 'test@email.com') }

      it 'creates new user' do
        expect { User.find_oauth(auth) }.to change(User, :count).by(1)
      end

      it 'creates authorization for user' do
        expect { User.find_oauth(auth) }.to change(Authorization, :count).by(1)
      end

      it 'adds email to user' do
        user = User.find_oauth(auth)
        expect(user.email).to eq 'test@email.com'
      end

      it 'adds provider & uid to user' do
        user = User.find_oauth(auth)
        authorization = user.authorizations.first

        expect(authorization.provider).to eq 'facebook'
        expect(authorization.uid).to eq '123456'
      end

      it 'returns the user' do
        expect(User.find_oauth(auth)).to be_a(User)
      end
    end
  end

  describe '#subscribed?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:other_question) { create(:question) }
    let!(:subscription) { create(:subscription, question: question, user: user) }

    it 'returns true' do
      expect(user).to be_subscribed(question)
    end

    it 'returns false' do
      expect(user).to_not be_subscribed(other_question)
    end
  end
end
