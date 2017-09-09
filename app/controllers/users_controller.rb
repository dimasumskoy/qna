class UsersController < ApplicationController

  def email
    @user = User.new
  end

  def set_email
    render json: params[:email]
  end
end
