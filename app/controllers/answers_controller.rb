class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_answer, only: [:show, :destroy, :update, :best]
  before_action :set_question, only: [:create]

  after_action :stream_answer, only: [:create]

  respond_to :js

  authorize_resource

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
      ApplicationController.render(json: @answer)
  end
end
