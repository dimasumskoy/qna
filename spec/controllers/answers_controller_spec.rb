require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it_behaves_like 'voted'

  describe 'POST #create' do
    user_sign_in
    
    context 'with valid attributes' do
      let(:valid_answer_attributes) { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }

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

      it 'renders create template' do
        valid_answer_attributes
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:invalid_answer_attributes) { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }

      it 'does not save the answer to question in db' do
        expect { invalid_answer_attributes }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        invalid_answer_attributes
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'authorized user tries to change his answer' do
      user_sign_in
      let!(:user_answer) { create(:answer, question: question, user: @user) }

      it 'assigns the requested answer to @answer' do
        patch :update, params: { answer: attributes_for(:answer), id: user_answer, question_id: question, format: :js }
        expect(assigns(:answer)).to eq user_answer
      end

      it 'changes the answer attributes and saves it in db' do
        patch :update, params: { answer: { body: 'edited body' }, id: user_answer, question_id: question, format: :js }
        user_answer.reload
        expect(user_answer.body).to eq 'edited body'
      end

      it 'renders update template' do
        patch :update, params: { answer: attributes_for(:answer), id: user_answer, question_id: question, format: :js }
        expect(response).to render_template :update
      end
    end

    context 'authorized user tries to change NOT his answer' do
      user_sign_in
      let!(:not_user_answer) { create(:answer, question: question, user: user) }

      it 'does not changes answer attributes and save it in db' do
        patch :update, params: { answer: attributes_for(:answer), id: not_user_answer, question_id: question, format: :js }
        expect(not_user_answer.body).to eq not_user_answer.body
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authorized user tries to delete his answer' do
      user_sign_in
      let!(:user_answer) { create(:answer, question: question, user: @user) }

      it 'assigns requested answer to @answer' do
        delete :destroy, params: { id: user_answer, format: :js }
        expect(assigns(:answer)).to eq user_answer
      end

      it 'deletes the answer from db' do
        expect { delete :destroy, params: { id: user_answer, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: user_answer, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'authorized user tries to delete NOT his answer' do
      user_sign_in
      let!(:not_user_answer) { create(:answer, question: question, user: user) }

      it 'does not deletes the answer from db' do
        expect { delete :destroy, params: { id: not_user_answer, format: :js } }.to_not change(Answer, :count)
      end

      it 're-renders destroy template' do
        delete :destroy, params: { id: not_user_answer, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #best' do
    user_sign_in
    let(:user_question) { create(:question, user: @user) }

    context 'author of the question marks the answer as best' do
      let!(:answer) { create(:answer, question: user_question, user: user) }

      it 'assigns the requested answer to @answer' do
        patch :best, params: { id: answer, format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'adds the best answer mark to @answer' do
        patch :best, params: { id: answer, format: :js }
        expect(assigns(:answer)).to be_best
      end

      it 'renders best action template' do
        patch :best, params: { id: answer, format: :js }
        expect(response).to render_template :best
      end
    end

    context 'other user tries to mark answer as best' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'does not marks the answer as best' do
        patch :best, params: { id: answer, format: :js }
        expect(assigns(:answer)).to_not be_best
      end
    end
  end
end
