class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  validates :body, :user_id, presence: true
  validates :commentable_type, inclusion: %w(Question Answer)
end
