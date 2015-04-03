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
      post '/api/profile/meals', {meal: {description: 'hamburguer', calories: 500, ate_at: DateTime.now}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :created
    end

    it 'should fail if no description is given' do
      post '/api/profile/meals', {meal: {description: '', calories: 500, ate_at: DateTime.now}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :unprocessable_entity
      expect(json_body[:error]).to include('Description can\'t be blank')
    end

    it 'should fail if no calories is given' do
      post '/api/profile/meals', {meal: {description: 'hamburguer', ate_at: DateTime.now}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :unprocessable_entity
      expect(json_body[:error]).to include('Calories is not a number')
    end

    it 'should fail if no ate_at is given' do
      post '/api/profile/meals', {meal: {description: 'hamburguer', calories: 100}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :unprocessable_entity
      expect(json_body[:error]).to include('Ate at can\'t be blank')
    end
  end
end