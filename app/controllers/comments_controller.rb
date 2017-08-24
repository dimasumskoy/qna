class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resource, only: [:create]

  after_action :stream_comment, only: [:create]

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def resource_context
    params[:comment][:context].classify.constantize
  end

  def resource_id
    "#{resource_context.to_s.downcase}_id".to_sym
  end

  def set_resource
    @resource = resource_context.find(params[resource_id])
  end

  def comment_params
    params.require(:comment).permit(:body, context: params[:comment][:context])
  end

  def stream_comment
    return if @comment.errors.any?
    question_id = @resource.try(:question_id) || @resource.id
    ActionCable.server.broadcast("question-#{question_id}-comments",
      ApplicationController.render(json: @comment)
    )
  end
end
