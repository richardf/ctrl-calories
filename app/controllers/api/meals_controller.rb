class API::MealsController < ApplicationController

  before_action :required_params, only: [:create, :update]
  before_action :get_user_meal, only: [:show, :update, :destroy]

  def index
    respond_with(@current_user.meals)
  end

  def create
    meal = Meal.new(@meal_params)
    meal.user = @current_user

    if meal.save
      respond_with(meal, location: api_profile_meal_url(meal.id))
    else
      render json: { error: meal.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    if @meal
      respond_with(@meal)
    else
      render json: { error: 'Meal not found' }, status: :not_found
    end
  end

  def update
    if @meal
      @meal = Meal.update(@meal.id, @meal_params)
      respond_with(@meal)
    else
      render json: { error: 'Meal not found' }, status: :not_found
    end
  end

  def destroy
    if @meal
      @meal.destroy
      respond_with(@meal)
    else
      render json: { error: 'Meal not found' }, status: :not_found
    end
  end


  private

  def required_params
    @meal_params = params.require(:meal).permit(:description, :calories, :ate_at_time, :ate_at_date)
  end

  def get_user_meal
    @meal = Meal.find_by(id: params[:id], user: @current_user)
  end
end
