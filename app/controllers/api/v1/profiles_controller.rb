class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :read, current_resource_owner
    respond_with current_resource_owner
  end

  def index
    authorize! :read, User
    return if current_resource_owner.nil?

    users = User.where.not(id: current_resource_owner.id)
    respond_with users
  end
end