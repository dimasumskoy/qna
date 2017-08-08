class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :destroy, :update, :vote_up, :vote_down, :revote]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.attachments.build
  end

  def new
    @question = current_user.questions.build
    @question.attachments.build
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    else
      render :update
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to @question, notice: 'Question successfully deleted.'
    else
      redirect_to @question
    end
  end

  def vote_up
    vote('vote_up')
  end

  def vote_down
    vote('vote_down')
  end

  def revote
    if @question.voted?(current_user)
      @question.revote(current_user)

      respond_to { |format| format.json { render json: @question.votes.count_rating } }
    else
      render :show
    end
  end

  private

  def vote(choice)
    if @question.voted?(current_user) || current_user.author_of?(@question)
      respond_to { |format| format.json { render json: t('vote_error'), status: :unprocessable_entity } }
    else
      @question.send(choice, current_user)
      respond_to { |format| format.json { render json: @question.votes.count_rating } }
    end
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
