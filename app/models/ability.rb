class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    user_create_abilities
    user_update_abilities
    user_best_abilities
    user_vote_abilities
  end

  private

  def user_create_abilities
    can :create,  [Question, Answer, Comment]
  end

  def user_update_abilities
    can [:update, :destroy], [Question, Answer], user: @user
  end

  def user_best_abilities
    can :best, Answer, question: { user_id: @user.id }
  end

  def user_vote_abilities
    can [:vote_up, :vote_down], [Question, Answer] { |votable| votable.user_id != @user.id }
    can :revote, [Question, Answer] { |votable| votable.voted?(@user) }
  end
end
