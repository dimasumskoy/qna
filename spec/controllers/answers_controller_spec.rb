require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #index' do
    before { get :index, params: { question_id: question } }

    it 'fills an array of answers to @answers' do
      expect(assigns(:answers)).to eq([answer])
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    user_sign_in

    before { get :new, params: { question_id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns the new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    user_sign_in
    
    context 'with valid attributes' do
      let(:valid_answer_attributes) { post :create, params: { answer: attributes_for(:answer), question_id: question } }

      it 'assigns the requested question to @question' do
        valid_answer_attributes
        expect(assigns(:question)).to eq question
      end

      it 'saves the answer to question in db' do
        expect { valid_answer_attributes }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        valid_answer_attributes
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:invalid_answer_attributes) { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }

      it 'does not save the answer to question in db' do
        expect { invalid_answer_attributes }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        invalid_answer_attributes
        expect(response).to render_template :new
      end
    end
  end
end
