require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  context '#best?' do
    it 'returns true' do
      answer.best!
      expect(answer.best?).to be_truthy
    end

    it 'returns false' do
      expect(answer.best?).to be_falsey
    end
  end
end
