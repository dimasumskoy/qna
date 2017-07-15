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

    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    user_sign_in
    
    context 'with valid attributes' do
      let(:valid_question_params) { post :create, params: { question: attributes_for(:question), user: @user } }

      it 'saves the new question in db' do
        expect { valid_question_params }.to change(Question, :count).by(1)
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

  describe 'DELETE #destroy' do
    context 'authorized user tries to delete his question' do
      user_sign_in

      let!(:user_question) { create(:question, user: @user) }
      let(:deleted_question) { delete :destroy, params: { id: user_question } }
     
      it 'deletes the question from db' do
        expect { deleted_question }.to change(Question, :count).by(-1)
      end

      it 'renders index view' do
        deleted_question
        expect(response).to redirect_to questions_path
      end
    end

    context 'authorized user tries to delete NOT his question' do
      user_sign_in

      let(:other_user) { create(:user) }
      let!(:other_question) { create(:question, user: other_user) }

      it 'does not deletes the question from db' do
        expect { delete :destroy, params: { id: other_question } }.to_not change(Question, :count)
      end
    end
  end
end
