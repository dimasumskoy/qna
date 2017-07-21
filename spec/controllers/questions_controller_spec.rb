require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    before { get :index }

    it 'fills an array of questions' do
      expect(assigns(:questions)).to eq([question])
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    user_sign_in

    before { get :new }

    it 'assigns the new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns the new question for current user' do
      expect(assigns(:question).user).to eq @user
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    user_sign_in
    
    context 'with valid attributes' do
      let(:valid_question_params) { post :create, params: { question: attributes_for(:question) } }

      it 'saves the new question in db for current user' do
        expect { valid_question_params }.to change(@user.questions, :count).by(1)
      end

      it 'renders show view' do
        valid_question_params
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:invalid_question_params) { post :create, params: { question: attributes_for(:invalid_question) } }

      it 'does not save the new question in db' do
        expect { invalid_question_params }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        invalid_question_params
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'authorized user changes his question' do
      user_sign_in
      let(:question) { create(:question, user: @user) }

      it 'assigns the requested question to @question' do
        patch :update, params: { question: attributes_for(:question), id: question }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes and saves it in db' do
        patch :update, params: { question: { title: 'edited title', body: 'edited body' }, id: question, format: :js }
        question.reload
        expect(question.title).to eq 'edited title'
        expect(question.body).to eq 'edited body'
      end

      it 're-renders update template' do
        patch :update, params: { question: attributes_for(:question), id: question }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'authorized user changes NOT his question' do
      user_sign_in

      it 'does not change attributes of question' do
        patch :update, params: { question: { title: 'edited title', body: 'edited body' }, id: question, format: :js }
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 'renders update template' do
        patch :update, params: { question: attributes_for(:question), id: question }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authorized user deletes his question' do
      user_sign_in

      let!(:user_question) { create(:question, user: @user) }
      let(:deleted_question) { delete :destroy, params: { id: user_question } }
     
      it 'deletes the question from db' do
        expect { deleted_question }.to change(Question, :count).by(-1)
      end

      it 'redirects to questions' do
        deleted_question
        expect(response).to redirect_to questions_path
      end
    end

    context 'authorized user deletes NOT his question' do
      user_sign_in

      let!(:not_user_question) { create(:question, user: user) }
      let(:not_deleted_question) { delete :destroy, params: { id: not_user_question } }

      it 'cannot delete the question from db' do
        expect { not_deleted_question }.to_not change(Question, :count)
      end

      it 'redirects to question' do
        not_deleted_question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end
