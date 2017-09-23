class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :commentable_type, :commentable_id, :user_id
end
