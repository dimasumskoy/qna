class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_answer, only: [:show, :destroy, :update]
  before_action :set_question, only: [:new, :create]

  def index
  end

  def show
  end

  def new
    @answer = current_user.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @question = @answer.question
    @answer.update(answer_params)
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @answer.question
    else
      redirect_to @answer.question, notice: 'Answer was not deleted'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
