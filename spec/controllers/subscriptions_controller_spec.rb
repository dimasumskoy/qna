require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }

  describe 'POST #create' do
    user_sign_in

    context 'Authorized user subscribes to question' do
      let(:subscription_params) { post :create, params: { question_id: question, user: @user, format: :json} }

      it 'creates new subscription' do
        expect { subscription_params }.to change(Subscription, :count).by(1)
      end

      it 'changes question subscriptions amount' do
        expect { subscription_params }.to change(question.subscriptions, :count).by(1)
      end

      it 'changes user subscriptions amount' do
        expect { subscription_params }.to change(@user.subscriptions, :count).by(1)
      end
    end
  end
end
