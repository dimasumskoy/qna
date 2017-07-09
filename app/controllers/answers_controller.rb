class AnswersController < ApplicationController
  def index
    @answers = Answer.all
  end

  def show
    @answer = Answer.find(params[:id])
  end

  def new
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
