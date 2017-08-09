module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end

  def vote_up(user)
    votes.create!(value: 1, user_id: user.id)
    update_rating
  end

  def vote_down(user)
    votes.create!(value: -1, user_id: user.id)
    update_rating
  end

  def revote(user)
    votes.find_by(user_id: user.id).destroy
    update_rating
  end

  def voted?(user)
    votes.exists?(user_id: user.id)
  end

  def to_string
    self.class.to_s.pluralize.downcase
  end

  private

  def update_rating
    update!(rating: self.votes.count_rating)
  end
end