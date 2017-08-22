class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
  validates :commentable_type, inclusion: %w(Question Answer)
end
