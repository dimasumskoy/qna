shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access token' do
      do_authorizable
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access token is invalid' do
      do_authorizable(access_token: '12345' )
      expect(response.status).to eq 401
    end
  end
end