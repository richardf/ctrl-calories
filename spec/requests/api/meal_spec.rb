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

    it 'should order by date/time ascending' do
      user = create(:user)
      Meal.create(description: 'food 1', user: user, ate_at_date: '2015-04-11', ate_at_time: '11:00', calories: 100);
      Meal.create(description: 'food 2', user: user, ate_at_date: '2015-04-10', ate_at_time: '11:00', calories: 100);
      Meal.create(description: 'food 3', user: user, ate_at_date: '2015-04-10', ate_at_time: '13:00', calories: 100);

      get '/api/profile/meals', {}, auth_header(user.login, user.password)
      expect(json_body[0][:description]).to eq('food 2')
      expect(json_body[1][:description]).to eq('food 3')
      expect(json_body[2][:description]).to eq('food 1')
    end

    context 'with filter' do
      let(:f_user) {create(:user)}
      let!(:meal_one) {Meal.create(user: f_user, ate_at_time: '09:30', ate_at_date: '2015-04-03', description: 'fish', calories: 300)}
      let!(:meal_two) {Meal.create(user: f_user, ate_at_time: '09:45', ate_at_date: '2015-04-04', description: 'gelado', calories: 250)}
      before(:each) {Meal.create(user: another_user, ate_at_time: '09:35', ate_at_date: '2015-04-04', description: 'beef', calories: 350)}
     
      it 'should return meals eaten at or after given day, for logged user' do
        get '/api/profile/meals?start_date=2015-04-04', {}, auth_header(f_user.login, f_user.password)
        expect(json_body.size).to eq 1
      end

      it 'should return meals eaten at or before given day, for logged user' do
        get '/api/profile/meals?end_date=2015-04-03', {}, auth_header(f_user.login, f_user.password)
        expect(json_body.size).to eq 1
      end

      it 'should return meals eaten at or after given time, for logged user' do
        get '/api/profile/meals?start_time=09:35', {}, auth_header(f_user.login, f_user.password)
        expect(json_body.size).to eq 1
      end

      it 'should return meals eaten at or before given time, for logged user' do
        get '/api/profile/meals?end_time=09:35', {}, auth_header(f_user.login, f_user.password)
        expect(json_body.size).to eq 1
      end

      it 'should support multiple filters' do
        Meal.create(user: f_user, ate_at_time: '08:55', ate_at_date: '2015-04-03', description: 'broccoli', calories: 300)
        get '/api/profile/meals?start_time=09:00&end_time=09:45', {}, auth_header(f_user.login, f_user.password)
        expect(json_body.size).to eq 2
      end
    end
  end


  context 'creating a meal' do
    let(:user) { create(:user) }

    it 'without authentication should give status not authorized' do
      post '/api/profile/meals', {}
      expect(response).to have_http_status :unauthorized
    end

    it 'should create a valid meal for user' do
      post '/api/profile/meals', {meal: {description: 'hamburguer', calories: 500, ate_at_time: Time.current, ate_at_date: Date.current}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :created
    end

    it 'should fail if no description is given' do
      post '/api/profile/meals', {meal: {description: '', calories: 500, ate_at_time: Time.current, ate_at_date: Date.current}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :unprocessable_entity
      expect(json_body[:error]).to include('Description can\'t be blank')
    end

    it 'should fail if no calories is given' do
      post '/api/profile/meals', {meal: {description: 'hamburguer', ate_at_time: Time.current, ate_at_date: Date.current}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :unprocessable_entity
      expect(json_body[:error]).to include('Calories is not a number')
    end

    it 'should fail if no ate_at_date is given' do
      post '/api/profile/meals', {meal: {description: 'hamburguer', calories: 100, ate_at_time: Time.current}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :unprocessable_entity
      expect(json_body[:error]).to include('Ate at date can\'t be blank')
    end

    it 'should fail if no ate_at_time is given' do
      post '/api/profile/meals', {meal: {description: 'hamburguer', calories: 100, ate_at_date: Date.current}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :unprocessable_entity
      expect(json_body[:error]).to include('Ate at time can\'t be blank')
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
      expect(json_body).to include(:ate_at_time)
      expect(json_body).to include(:ate_at_date)
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
