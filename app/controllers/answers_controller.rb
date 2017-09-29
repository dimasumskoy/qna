class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_answer, only: [:show, :destroy, :update, :best]
  before_action :set_question, only: [:create]

  after_action :send_notification, only: [:create]
  after_action :stream_answer, only: [:create]

  authorize_resource

  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    respond_with @answer
  end

  def destroy
    @question = @answer.question
    respond_with(@answer.destroy) if current_user.author_of?(@answer)
  end

  def best
    respond_with(@answer.best!) if current_user.author_of?(@answer.question)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def stream_answer
    return if @answer.errors.any?
    AnswersChannel.broadcast_to @question,
      AnswerSerializer.new(@answer).to_json
  end

  def send_notification
    @question.user.new_answer_notification(@question)
  end
end
