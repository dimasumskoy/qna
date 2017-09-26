shared_examples_for 'Votes validatable' do
  it { should have_many(:votes).dependent(:delete_all) }
end