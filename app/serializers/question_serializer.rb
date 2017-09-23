class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :user_id, :rating

  has_many :comments
  has_many :attachments
  has_many :answers
end
