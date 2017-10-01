shared_examples_for 'Subscribeable' do
  it { should have_many(:subscriptions).dependent(:destroy) }
end