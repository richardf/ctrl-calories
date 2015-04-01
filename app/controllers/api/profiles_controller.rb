class API::ProfilesController < ApplicationController

  def create
    profile_params = params.require(:user).permit(:name, :login, :expected_calories)
    user = User.create(profile_params)
    respond_with(user, location: api_profile_url)
  end

  def edit
    respond_with(User.last)
  end

  def show
    respond_with(User.last)
  end

  def update
    profile_params = params.require(:user).permit(:name, :expected_calories)
    respond_with(User.last.update(profile_params))
  end
end