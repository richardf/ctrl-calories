class API::MealsController < ApplicationController

  def index
    respond_with(@current_user.meals)
  end

  def create
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
