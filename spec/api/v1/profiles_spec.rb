require 'rails_helper'
require_relative 'concerns/unauthorized_spec.rb'

RSpec.describe Api::V1::ProfilesController, type: :controller do
  describe 'GET /me' do
    it_behaves_like 'API Authenticable'

    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    context 'authorized' do
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

    def do_authenticable(options = {})
      get :me, params: { format: :json }.merge(options)
    end
  end

  describe 'GET #index' do
    it_behaves_like 'API Authenticable'

    let!(:users) { create_list(:user, 3) }
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    context 'authorized' do
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
          expect(response.body).to have_json_path("0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains #{attr} for each user" do
          expect(response.body).to_not have_json_path("0/#{attr}")
        end
      end
    end

    def do_authenticable(options = {})
      get :index, params: { format: :json }.merge(options)
    end
  end
end