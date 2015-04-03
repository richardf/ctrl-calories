class API::MealsController < ApplicationController

  def index
    respond_with(@current_user.meals)
  end

  def create
    meal_params = params.require(:meal).permit(:description, :calories, :ate_at)
    meal = Meal.new(meal_params)
    meal.user = @current_user

    if meal.save
      respond_with(@meal, location: api_profile_meal_url(meal.id))
    else
      render json: { error: meal.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end
end
