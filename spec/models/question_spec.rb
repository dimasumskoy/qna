require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:votes).dependent(:delete_all) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for :attachments }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it_behaves_like 'votable'
end