require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe 'POST #create' do
    context 'Authorized user subscribes to question' do
      user_sign_in
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

    context 'Unauthorized user tries to subscribe to question' do
      it 'does not create new subscription' do
        expect { post :create, params: { question_id: question, format: :json } }.to_not change(Subscription, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authorized user tries to unsubscribe from question' do
      user_sign_in
      let!(:subscription) { create(:subscription, question: question, user: @user) }
      let(:subscription_params) { delete :destroy, params: { id: subscription, question_id: question, format: :json } }

      it 'deletes subscription from db' do
        expect { subscription_params }.to change(Subscription, :count).by(-1)
      end

      it 'deletes subscription for question' do
        expect { subscription_params }.to change(question.subscriptions, :count).by(-1)
      end

      it 'deletes subscription for user' do
        expect { subscription_params }.to change(@user.subscriptions, :count).by(-1)
      end
    end

    context 'Unauthorized user tries to unsubscribe' do
      user_sign_in
      let!(:subscription) { create(:subscription, question: question, user: user) }

      it 'does not delete subscription from db' do
        expect { delete :destroy, params: { id: subscription, question_id: question, format: :json } }.to_not change(Subscription, :count)
      end
    end
  end
end
