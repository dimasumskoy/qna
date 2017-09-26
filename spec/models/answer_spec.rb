require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'Attachments validatable'
  it_behaves_like 'Votes validatable'
  it_behaves_like 'Votable'

  it { should belong_to(:user) }
  it { should belong_to(:question) }
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

  context '.ordered' do
    it 'orders the list of answers by best' do
      Answer.last.best!
      expect(Answer.ordered.first.best?).to eq true
    end
  end
end
