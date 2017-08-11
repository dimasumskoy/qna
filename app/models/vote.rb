class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true

  validates :votable, :value, presence: true
  validates :votable_type, inclusion: %w(Question Answer)
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  scope :count_positive, -> { where(value: 1).count }
  scope :count_negative, -> { where(value: -1).count }
  scope :count_rating, -> { count_positive - count_negative }
end
