class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resource, only: [:create]

  after_action :stream_comment, only: [:create]

  respond_to :js

  authorize_resource

  def create
    respond_with(@comment = @resource.comments.create(comment_params.merge(user: current_user)))
  end

  private

  def set_resource
    klass = [Question, Answer].detect { |klass| params["#{klass.name.underscore}_id"] }
    @resource = klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def stream_comment
    return if @comment.errors.any?
    question_id = @resource.try(:question_id) || @resource.id
    ActionCable.server.broadcast("question-#{question_id}-comments",
      ApplicationController.render(json: @comment)
    )
  end
end
