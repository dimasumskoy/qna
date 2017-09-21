require 'rails_helper'

RSpec.describe Api::V1::ProfilesController, type: :controller do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get :me, format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get :me, format: :json, params: { access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { get :me, params: { access_token: access_token.token }, format: :json }

      it 'returns status 200' do
        expect(response).to be_success
      end
    end
  end
end