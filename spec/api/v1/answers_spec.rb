require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 2, question: question) }
  let(:answer) { answers.first }
  let(:access_token) { create(:access_token).token }

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

  describe 'GET #index' do
    before { get :index, params: { question_id: question, access_token: access_token }, format: :json }

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

  describe 'GET #show' do
    let!(:attachment) { create(:attachment, attachable: answer) }
    let!(:comment) { create(:comment, commentable: answer) }

    before { get :show, params: {id: answers.first.id, question_id: question, access_token: access_token }, format: :json }

    it 'contains answer' do
      expect(response.body).to have_json_path('answer')
    end

    %w(id body created_at updated_at question_id user_id best rating).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(answers.first.send(attr).to_json).at_path("answer/#{attr}")
      end
    end

    %w(comments attachments).each do |association|
      it "contains #{association}" do
        expect(response.body).to have_json_path("answer/#{association}")
      end
    end

    it 'contains file for the attachment' do
      expect(response.body).to be_json_eql(attachment.file.to_json).at_path('answer/attachments/0/file')
    end

    it 'contains comment body' do
      expect(response.body).to be_json_eql(comment.body.to_json).at_path('answer/comments/0/body')
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'with valid attributes' do
      let(:valid_answer_params) do
        post :create, params: { answer: { body: 'test_body' }, question_id: question,
                                access_token: access_token, format: :json }
      end

      it 'returns status 201' do
        valid_answer_params
        expect(response.status).to eql 201
      end

      it 'saves new answer in db' do
        expect { valid_answer_params }.to change(question.answers, :count).by(1)
      end

      it 'contains answer attributes' do
        valid_answer_params
        expect(Answer.last).to have_attributes(body: 'test_body')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_answer_params) do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question,
                                access_token: access_token, format: :json }
      end

      it 'returns status 422 Unprocessable Entity' do
        invalid_answer_params
        expect(response.status).to eql 422
      end

      it 'does not saves new answer in db' do
        expect { invalid_answer_params }.to_not change(Answer, :count)
      end
    end
  end
end