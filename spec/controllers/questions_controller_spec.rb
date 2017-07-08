require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

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
    before { get :new }

    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_question_params) { post :create, params: { question: attributes_for(:question) } }

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
end
