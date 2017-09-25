shared_examples_for 'Question and Answer common validatable' do
  it { should belong_to(:user) }
  it { should have_many(:attachments) }
  it { should have_many(:votes).dependent(:delete_all) }
  it { should accept_nested_attributes_for(:attachments) }
  it { should validate_presence_of :body }
end