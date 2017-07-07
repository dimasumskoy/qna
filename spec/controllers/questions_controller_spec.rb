require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    it 'fills an array of questions' do
      get :index
      expect(assigns(:questions)).to match_array(questions)
    end
  end
end
