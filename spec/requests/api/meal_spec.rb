require 'rails_helper'

describe "Meal API",  type: :request do

  context 'listing meals' do
    let(:user) { create(:user, :with_meals, meal_count: 3) }
    let(:another_user) { create(:user, :with_meals, meal_count: 2) }

    it 'without authentication should give status not authorized' do
      get '/api/profile/meals'
      expect(response).to have_http_status :unauthorized
    end

    it 'should return user meals' do
      get '/api/profile/meals', {}, auth_header(user.login, user.password)
      expect(json_body.size).to eq 3
    end
  end


  context 'creating a meal' do
    let(:user) { create(:user) }

    it 'without authentication should give status not authorized' do
      post '/api/profile/meals', {}
      expect(response).to have_http_status :unauthorized
    end

    it 'should create a valid meal for user' do
      post '/api/profile/meals', {meal: {description: 'hamburguer', calories: 500, ate_at: Time.current}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :created
    end

    it 'should fail if no description is given' do
      post '/api/profile/meals', {meal: {description: '', calories: 500, ate_at: Time.current}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :unprocessable_entity
      expect(json_body[:error]).to include('Description can\'t be blank')
    end

    it 'should fail if no calories is given' do
      post '/api/profile/meals', {meal: {description: 'hamburguer', ate_at: Time.current}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :unprocessable_entity
      expect(json_body[:error]).to include('Calories is not a number')
    end

    it 'should fail if no ate_at is given' do
      post '/api/profile/meals', {meal: {description: 'hamburguer', calories: 100}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :unprocessable_entity
      expect(json_body[:error]).to include('Ate at can\'t be blank')
    end
  end


  context 'displaying a meal' do
    let(:user) { create(:user, :with_meals, meal_count: 2) }
    let(:another_user) { create(:user, :with_meals, meal_count: 2) }

    it 'without authentication should give status not authorized' do
      get '/api/profile/meals/1'
      expect(response).to have_http_status :unauthorized
    end

    it 'should return meal data' do
      get '/api/profile/meals/' + user.meals.first.id.to_s, {}, auth_header(user.login, user.password)
      expect(response).to have_http_status :ok
      expect(json_body[:id]).to eq(user.meals.first.id)
      expect(json_body[:description]).to eq(user.meals.first.description)
      expect(json_body[:calories]).to eq(user.meals.first.calories)
      expect(json_body).to include(:ate_at)
    end

    it 'should give error if meal doesnt belong to user' do
      get '/api/profile/meals/' + another_user.meals.first.id.to_s, {}, auth_header(user.login, user.password)
      expect(response).to have_http_status :not_found
      expect(json_body[:error]).to eq('Meal not found')
    end

    it 'should give error if meal doesnt exist' do
      get '/api/profile/meals/123123123123', {}, auth_header(user.login, user.password)
      expect(response).to have_http_status :not_found
      expect(json_body[:error]).to eq('Meal not found')
    end
  end


  context 'updating a meal' do
    let(:user) { create(:user, :with_meals, meal_count: 2) }
    let(:another_user) { create(:user, :with_meals, meal_count: 2) }

    it 'without authentication should give status not authorized' do
      put '/api/profile/meals/1'
      expect(response).to have_http_status :unauthorized
    end

    it 'should not update meal owner' do
      put '/api/profile/meals/' + user.meals.first.id.to_s, {meal:{id: user.meals.first.id, user_id: another_user.id}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :no_content
      expect(Meal.find(user.meals.first.id).user.id).to eq(user.id)
    end

    it 'should not update meal of other user' do
      put '/api/profile/meals/' + another_user.meals.first.id.to_s, {meal:{id: another_user.meals.first.id, description: 'eat eat eat'}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :not_found
      expect(Meal.find(another_user.meals.first.id).description).to eq(another_user.meals.first.description)
    end

    it 'should update meal' do
      put '/api/profile/meals/' + user.meals.first.id.to_s, {meal:{id: user.meals.first.id, description: 'eat eat', calories: 99999}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :no_content
      meal = Meal.find(user.meals.first.id)
      expect(meal.description).to eq('eat eat')
      expect(meal.calories).to eq(99999)
    end
  end


  context 'deleting meal' do
    let(:user) { create(:user, :with_meals, meal_count: 2) }
    let(:another_user) { create(:user, :with_meals, meal_count: 2) }

    it 'without authentication should give status not authorized' do
      delete '/api/profile/meals/1'
      expect(response).to have_http_status :unauthorized
    end

    it 'should delete meal' do
      meal_id = user.meals.first.id
      delete '/api/profile/meals/' + meal_id.to_s, {}, auth_header(user.login, user.password)
      expect(response).to have_http_status :no_content
      expect(Meal.find_by(id: meal_id)).to be nil
    end

    it 'should not delete meal of other user' do
      meal_id = another_user.meals.first.id
      delete '/api/profile/meals/' + meal_id.to_s, {}, auth_header(user.login, user.password)
      expect(response).to have_http_status :not_found
      expect(Meal.find(meal_id)).to be_kind_of(Meal)
    end
  end
end
