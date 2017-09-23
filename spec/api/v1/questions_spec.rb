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
        it "contains #{attr} for each question in list" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("questions/0/#{attr}")
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:question) { create(:question) }
    let(:access_token) { create(:access_token) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let(:comment) { comments.first }
    let!(:attachment) { create(:attachment, attachable: question) }

    before { get :show, params: { id: question, access_token: access_token.token }, format: :json }

    context 'question comments' do
      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("question/#{attr}")
        end
      end

      it 'contains comments path' do
        expect(response.body).to have_json_path('question/comments')
      end

      it 'returns correct amount of comments' do
        expect(response.body).to have_json_size(comments.size).at_path('question/comments')
      end

      it 'returns comment body' do
        expect(response.body).to be_json_eql(comment.body.to_json).at_path('question/comments/1/body')
      end
    end

    context 'question attachments' do
      it 'contains attachments path' do
        expect(response.body).to have_json_path('question/attachments')
      end

      it 'returns correct amount of attachments' do
        expect(response.body).to have_json_size(1).at_path('question/attachments')
      end

      it 'contains attachment file' do
        expect(response.body).to be_json_eql(attachment.file.to_json).at_path('question/attachments/0/file')
      end
    end
  end
end