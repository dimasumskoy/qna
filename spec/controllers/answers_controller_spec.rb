require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

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

    it 'assigns the new question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns the new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns the new answer for current user' do
      expect(assigns(:answer).user).to eq @user
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

      it 'saves the answer for current user' do
        expect { valid_answer_attributes }.to change(@user.answers, :count).by(1)
      end

      it 'saves the answer to question in db' do
        expect { valid_answer_attributes }.to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_answer_attributes) { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }

      it 'does not save the answer to question in db' do
        expect { invalid_answer_attributes }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authorized user deletes his answer' do
      user_sign_in
      let!(:user_answer) { create(:answer, question: question, user: @user) }

      it 'deletes the answer from db' do
        expect { delete :destroy, params: { id: user_answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to answer question' do
        delete :destroy, params: { id: user_answer }
        expect(response).to redirect_to (assigns(:answer).question)
      end
    end

    context 'authorized user deletes NOT his answer' do
      user_sign_in
      let!(:not_user_answer) { create(:answer, question: question, user: user) }

      it 'does not deletes the answer from db' do
        expect { delete :destroy, params: { id: not_user_answer } }.to_not change(Answer, :count)
      end

      it 'redirects to answer question' do
        delete :destroy, params: { id: not_user_answer }
        expect(response).to redirect_to (assigns(:answer).question)
      end
    end
  end
end
