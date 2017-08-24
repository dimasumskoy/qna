class CommentsChannel < ApplicationCable::Channel
  def subscribed
    id = params[:question_id]
    stream_from "question-#{id}-comments"
  end
end