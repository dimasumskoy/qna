require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:users) { create_list(:user, 2) }
  let(:user_question) { create(:question, user: users[0]) }
  let(:not_user_question) { create(:question, user: users[1]) }

  context '#author_of?' do
    it 'returns true' do
      expect(users[0].author_of?(user_question)).to be_truthy
    end

    it 'returns false' do
      expect(users[0].author_of?(not_user_question)).to be_falsey
    end
  end
end
