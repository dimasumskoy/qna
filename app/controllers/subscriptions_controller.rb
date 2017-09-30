class SubscriptionsController < ApplicationController
  before_action :set_question
  skip_authorization_check

  respond_to :json

  def create
    @subscription = @question.subscribe(current_user)
    respond_to { |format| format.json { render json: @subscription } }
  end

  def destroy
    @unsubscribed = @question.unsubscribe(current_user)
    respond_to { |format| format.json { render json: @unsubscribed } }
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
