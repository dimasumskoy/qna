class AnswersController < ApplicationController
  def index
    @answers = Answer.all
  end

  def show
    @answer = Answer.find(params[:id])
  end
end
