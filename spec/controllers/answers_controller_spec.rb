require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #index' do
    before do
      @question = create(:question)
      @answer = create(:answer, question_id: @question.id )
      get :index, params: { question_id: @question }
    end

    it 'fills an array of answers to @answers' do
      expect(assigns(:answers)).to eq([@answer])
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
