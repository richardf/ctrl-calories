class API::ProfilesController < ApplicationController

  skip_before_action :authenticate_request, only: [:create]


  def create
    profile_params = params.require(:user).permit(:name, :login, :password, :expected_calories)
    user = User.create(profile_params)

    if user.persisted?
      respond_with(user, location: api_profile_url)
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    calories = User.where(id: @current_user.id).calories_today
    response = @current_user.as_json
    response['consumed_calories'] = calories
    respond_with(response)
  end

  def update
    profile_params = params.require(:user).permit(:name, :password, :expected_calories)

    if profile_params.include?(:password) && !User.password_valid?(profile_params[:password])
      render json: { error: 'Invalid password' }, status: :unprocessable_entity 
    else
      user = User.update(@current_user.id, profile_params)
      respond_with(user)
    end
  end
end