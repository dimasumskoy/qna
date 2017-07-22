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

    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      render :update
    end
  end

  def destroy
    @question = @answer.question
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      flash[:notice] = 'You cannot delete this answer'
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
