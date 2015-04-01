class API::MealsController < ApplicationController

  def index
    respond_with(User.first.meals)
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
