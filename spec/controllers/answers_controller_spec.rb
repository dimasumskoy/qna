require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) do
    @question = create(:question)
    create(:answer, question_id: @question.id )
  end

  describe 'GET #index' do
    before do
      answer
      get :index, params: { question_id: @question }
    end

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
end
