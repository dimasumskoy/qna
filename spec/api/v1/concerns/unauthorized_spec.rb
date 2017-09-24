require 'rails_helper'

shared_examples_for 'unauthorized' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access token' do
      request_without_token
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access token is invalid' do
      request_with_invalid_token
      expect(response.status).to eq 401
    end
  end
end