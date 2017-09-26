require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'Attachments validatable'
  it_behaves_like 'Votes validatable'
  it_behaves_like 'Votable'

  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end