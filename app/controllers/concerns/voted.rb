module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_votable, only: [:vote_up, :vote_down, :revote]
  end

  def vote_up
    vote('vote_up')
  end

  def vote_down
    vote('vote_down')
  end

  def revote
    if @votable.voted?(current_user)
      @votable.revote(current_user)

      respond_to { |format| format.json { render json: @votable } }
    else
      respond_to { |format| format.json { render text: t('vote_error', resource: @votable.to_string.singularize), status: :unprocessable_entity } }
    end
  end

  private

  def vote(choice)
    if @votable.voted?(current_user) || current_user.author_of?(@votable)
      respond_to { |format| format.json { render json: t('vote_error', resource: @votable.to_string.singularize), status: :unprocessable_entity } }
    else
      @votable.send(choice, current_user)
      respond_to { |format| format.json { render json: @votable } }
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end