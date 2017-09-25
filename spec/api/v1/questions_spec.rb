require 'rails_helper'
require_relative 'concerns/unauthorized_spec.rb'

RSpec.describe Api::V1::QuestionsController, type: :controller do
  let(:access_token) { create(:access_token).token }

  describe 'GET #index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 3) }

      before { get :index, params: { access_token: access_token }, format: :json }

      it 'returns status 200' do
        expect(response).to be_success
      end

      it 'returns correct amount of questions' do
        expect(response.body).to have_json_size(questions.size).at_path('questions')
      end

      %w(id created_at updated_at title body).each do |attr|
        it "contains #{attr} for each question in list" do
          expect(response.body).to be_json_eql(questions.first.send(attr).to_json).at_path("questions/0/#{attr}")
        end
      end
    end

    def do_authenticable(options = {})
      get :index, params: { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    it_behaves_like 'API Authenticable'

    let!(:question) { create(:question) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let!(:attachment) { create(:attachment, attachable: question) }

    context 'authorized' do
      before { get :show, params: { id: question, access_token: access_token }, format: :json }

      context 'attributes' do
        %w(id title body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("question/#{attr}")
          end
        end
      end

      context 'question comments' do
        it 'contains comments path' do
          expect(response.body).to have_json_path('question/comments')
        end

        it 'returns correct amount of comments' do
          expect(response.body).to have_json_size(comments.size).at_path('question/comments')
        end

        it 'returns comment body' do
          expect(response.body).to be_json_eql(comments.first.body.to_json).at_path('question/comments/1/body')
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

    def do_authenticable(options = {})
      get :show, params: { id: question, format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'with valid attributes' do
        let(:valid_question_params) do
          post :create, params: { question: { title: 'test_title', body: 'test_body' }, access_token: access_token, format: :json }
        end

        it 'returns status 201' do
          valid_question_params
          expect(response.status).to eql 201
        end

        it 'saves new question in db' do
          expect { valid_question_params }.to change(Question, :count).by(1)
        end

        it 'contains question attributes' do
          valid_question_params
          expect(Question.last).to have_attributes(title: 'test_title', body: 'test_body')
        end
      end

      context 'with invalid attributes' do
        let(:invalid_question_params) do
          post :create, params: { question: attributes_for(:invalid_question), access_token: access_token, format: :json }
        end

        it 'returns status 422 Unprocessable Entity' do
          invalid_question_params
          expect(response.status).to eql 422
        end

        it 'does not saves new question in db' do
          expect { invalid_question_params }.to_not change(Question, :count)
        end
      end
    end

    def do_authenticable(options = {})
      post :create, params: { question: { title: 'test_title', body: 'test_body' }, format: :json }.merge(options)
    end
  end
end