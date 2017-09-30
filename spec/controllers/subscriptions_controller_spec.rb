require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }

  describe 'POST #create' do
    user_sign_in

    context 'Authorized user subscribes to question' do
      let(:subscription_params) { post :create, params: { question_id: question, format: :json} }
    end
  end
end
