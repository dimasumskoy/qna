class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_answer, only: [:show, :destroy]
  before_action :set_question, only: [:new, :create]

  def index
    @answers = Answer.all
  end

  def show
  end

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.answers.include?(@answer)
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
