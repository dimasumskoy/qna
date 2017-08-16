class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :destroy, :update]
  after_action :stream_question, only: [:create]

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

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def stream_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(json: @question)
    )
  end
end
