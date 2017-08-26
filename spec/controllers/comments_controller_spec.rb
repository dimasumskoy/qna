require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let(:comment) { create(:comment, commentable: question) }

  describe 'POST #create' do
    user_sign_in

    context 'with valid attributes' do
      let(:valid_comment_attributes) { post :create, params: { comment: attributes_for(:comment, context: 'Question'), question_id: question, format: :js } }

      it 'assigns requested resource to @resource (question)' do
        valid_comment_attributes
        expect(assigns(:resource)).to eq question
      end

      it 'saves the comment for current user' do
        expect { valid_comment_attributes }.to change(@user.comments, :count).by(1)
      end

      it 'saves the comment for requested question' do
        expect { valid_comment_attributes }.to change(question.comments, :count).by(1)
      end

      it 'renders create template' do
        valid_comment_attributes
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:invalid_comment_attributes) do
        post :create, params: { comment: attributes_for(:invalid_comment, context: 'Question'), question_id: question, format: :js }
      end

      it 'does not save comment to resource in db' do
        expect { invalid_comment_attributes }.to_not change(Comment, :count)
      end

      it 'renders create template with respective errors' do
        invalid_comment_attributes
        expect(response).to render_template :create
      end
    end
  end
end
