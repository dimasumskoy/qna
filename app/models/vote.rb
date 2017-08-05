class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true

  validates :votable_type, inclusion: %w(Question Answer)

  scope :count_positive, -> { where(value: 1).size }
  scope :count_negative, -> { where(value: -1).size }
  scope :count_rating, -> { count_positive - count_negative }
end
