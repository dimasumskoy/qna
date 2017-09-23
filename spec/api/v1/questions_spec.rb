require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :controller do
  describe 'GET #index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get :index, format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get :index, format: :json, params: { access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 3) }
      let(:question) { questions.first }
      let(:access_token) { create(:access_token) }

      before { get :index, params: { access_token: access_token.token }, format: :json }

      it 'returns status 200' do
        expect(response).to be_success
      end

      it 'returns correct amount of questions' do
        expect(response.body).to have_json_size(questions.size).at_path('questions')
      end

      %w(id created_at updated_at title body).each do |attr|
        it "returns #{attr} for each question in list" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("questions/0/#{attr}")
        end
      end
    end
  end
end