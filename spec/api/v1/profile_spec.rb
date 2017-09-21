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

      %w(id created_at updated_at email admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(user.send(attr).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET #index' do
    let!(:users) { create_list(:user, 3) }
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    before { get :index, params: { access_token: access_token.token }, format: :json }

    it 'returns status 200' do
      expect(response).to be_success
    end

    it 'returns correct amount of users' do
      expect(response.body).to have_json_size(users.size)
    end

    it 'does not contains current resource owner' do
      expect(response.body).to_not include_json(user.to_json)
    end

    it 'contains all users' do
      users.each do |user|
        expect(response.body).to include_json(user.to_json)
      end
    end

    %w(id created_at updated_at email admin).each do |attr|
      it "contains #{attr} for each user" do
        users.each_index do |i|
          expect(response.body).to have_json_path("#{i}/#{attr}")
        end
      end
    end

    %w(password encrypted_password).each do |attr|
      it "does not contains #{attr} for each user" do
        users.each_index do |i|
          expect(response.body).to_not have_json_path("#{i}/#{attr}")
        end
      end
    end
  end
end