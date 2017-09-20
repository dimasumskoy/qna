class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment

  respond_to :js

  skip_authorization_check

  def destroy
    respond_with(@attachment.destroy) if current_user.author_of?(@attachment.attachable)
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end