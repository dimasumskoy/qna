class AddQuestionIdToAttachments < ActiveRecord::Migration[5.1]
  def change
    add_reference :attachments, :question
  end
end
