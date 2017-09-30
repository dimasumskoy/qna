class SubscriptionsController < ApplicationController
  before_action :set_question, only: :create
  skip_authorization_check

  respond_to :json

  def create
    @subscription = @question.subscribe(current_user)
    respond_to { |format| format.json { render json: @subscription } }
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
