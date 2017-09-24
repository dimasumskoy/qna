class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    @questions = Question.all
    respond_with @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, each_serializer: QuestionSerializer
  end

  def create
    @question = Question.create(question_params.merge(user: current_resource_owner))
    respond_with @question, each_serializer: QuestionSerializer
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end