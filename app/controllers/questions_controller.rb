class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :destroy, :update]
  before_action :save_user, :set_answer, only: [:show]

  after_action :stream_question, only: [:create]

  respond_to :js, only: [:update]

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = current_user.questions.build)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
    respond_with @question
  end

  def destroy
    if current_user.author_of?(@question)
      respond_with@question.destroy
    else
      redirect_to @question
    end
  end

  private

  def save_user
    gon.current_user = current_user if current_user
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def set_answer
    @answer = @question.answers.new
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def stream_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions',
      ApplicationController.render(json: @question)
    )
  end
end
