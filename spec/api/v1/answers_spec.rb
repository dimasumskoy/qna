require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 2, question: question) }
  let(:access_token) { create(:access_token) }

  describe 'GET #index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get :index, params: { question_id: question }, format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get :index, format: :json, params: { question_id: question, access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get :index, params: { question_id: question, access_token: access_token.token }, format: :json }

      it 'returns status 200' do
        expect(response).to be_success
      end

      it 'contains answers' do
        expect(response.body).to have_json_path('answers')
      end

      %w(id body created_at updated_at question_id user_id best rating attachments).each do |attr|
        it "contains #{attr} for each answer in the list" do
          expect(response.body).to be_json_eql(answers.first.send(attr).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end
end