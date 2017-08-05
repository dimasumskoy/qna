class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  has_many :votes, as: :votable, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  def vote_up(user)
    votes.create!(value: 1, user_id: user.id)
  end

  def vote_down(user)
    votes.create!(value: -1, user_id: user.id)
  end

  def revote(user)
    votes.find_by(user_id: user.id).destroy
  end

  def voted?(user)
    votes.exists?(user_id: user.id)
  end
end
