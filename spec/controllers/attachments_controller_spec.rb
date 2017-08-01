require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:file) { File.open("#{Rails.root}/spec/spec_helper.rb") }

  describe 'DELETE #destroy' do
    context 'Authorized user tries to delete attachment from his resource' do
      user_sign_in
      let(:question) { create(:question, user: @user) }
      let!(:attachment) { question.attachments.create!(file: file) }

      it 'assigns the requested attachment to @attachment' do
        delete :destroy, params: { id: attachment, format: :js }
        expect(assigns(:attachment)).to eq attachment
      end

      it 'deletes attachment from db' do
        expect { delete :destroy, params: { id: attachment, format: :js } }.to change(Attachment, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: attachment, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'Authorized user tries to delete attachment form someone else resource' do
      user_sign_in
      let(:user) { create(:user) }
      let(:other_question) { create(:question, user: user) }
      let!(:other_attachment) { other_question.attachments.create!(file: file) }

      it 'does not deletes an attachment from db' do
        expect { delete :destroy, params: { id: other_attachment, format: :js } }.to_not change(Attachment, :count)
      end

      it 're-renders destroy template' do
        delete :destroy, params: { id: other_attachment, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end
end