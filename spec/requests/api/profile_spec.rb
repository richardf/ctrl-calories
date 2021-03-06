require 'rails_helper'

describe "Profile API",  type: :request do

  context 'when registering' do
    context 'a valid user' do
      before(:each) { post '/api/profile', {user: {login: 'syme@email.com', name: 'Syme', password: 'foobar'}} }

      it 'should return status created' do
        expect(response).to have_http_status :created
      end

      it 'should register the user into system' do
        expect(User.find_by(login: 'syme@email.com')).not_to be nil
      end
    end

    context 'an invalid user' do
      it 'should return error if user is already registered' do
        u = create(:user)
        post '/api/profile', {user: {login: u.login, password: 'foobar'}}
        expect(response).to have_http_status :unprocessable_entity
        expect(json_body[:error]).to include('Email has already been taken')
      end

      it 'should return error if password is too short' do
        post '/api/profile', {user: {login: 'foo@email.com', password: 'foo'}}
        expect(response).to have_http_status :unprocessable_entity
        expect(json_body[:error]).to include('Password is too short (minimum is 6 characters)')
      end

      it 'should return error if login is not an email' do
        post '/api/profile', {user: {login: 'foooooo', password: 'foobar'}}
        expect(response).to have_http_status :unprocessable_entity
        expect(json_body[:error]).to include('Email is invalid')
      end

      it 'should return error if login is not informed' do
        post '/api/profile', {user: {password: 'foobar'}}
        expect(response).to have_http_status :unprocessable_entity
        expect(json_body[:error]).to include('Email can\'t be blank')
      end
    end
  end


  context 'when updating' do
    let(:user) { create(:user) }

    it 'without authentication should give status not authorized' do
      put '/api/profile', {user: {name: 'Mr Foo'}}
      expect(response).to have_http_status :unauthorized
    end

    it 'should not update login' do
      put '/api/profile', {user: {login: 'new@login.com'}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :no_content
      expect(User.find(user.id).login).to eq(user.login)
    end

    it 'should update name, expected_calories' do
      put '/api/profile', {user: {name: 'new name', expected_calories: 12345}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :no_content
      expect(User.find(user.id).name).to eq('new name')
      expect(User.find(user.id).expected_calories).to eq(12345)
    end

    it 'should be able to use the new password' do
      put '/api/profile', {user: {password: 'new_password'}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :no_content
      post '/api/auth', {login: user.login, password: 'new_password'}
      expect(response).to have_http_status :ok
    end    

    it 'should validate the new password' do
      put '/api/profile', {user: {password: 'short'}}, auth_header(user.login, user.password)
      expect(response).to have_http_status :unprocessable_entity
    end    
  end


  context 'when displaying' do
    it 'without authentication should give status not authorized' do
      get '/api/profile'
      expect(response).to have_http_status :unauthorized
    end

    it 'with wrong credentials should give status not authorized' do
      user = create(:user)
      get '/api/profile', {}, auth_header(user.login, 'wrong_password')
      expect(response).to have_http_status :unauthorized
    end

    it 'with fake auth token should give status not authorized' do
      get '/api/profile', {}, {'Authorization' => 'Bearer foofoofooofooofoofoofoo'}
      expect(response).to have_http_status :unauthorized
    end

    it 'with expired token should give status not authorized' do
      user = create(:user)
      payload = { user_id: user.id }
      token = AuthTokenEncoder.encode(payload, 1.minute.ago)
      get '/api/profile', {}, {'Authorization' => "Bearer #{token}"}
      expect(response).to have_http_status :unauthorized
      expect(json_body[:error]).to include('Auth token is expired')
    end

    context 'if authenticated' do
      let(:user) { create(:user) }

      it 'should return status ok' do
        get '/api/profile', {}, auth_header(user.login, user.password)
        expect(response).to have_http_status :ok
      end

      it 'should return user profile information' do
        get '/api/profile', {}, auth_header(user.login, user.password)
        expect(json_body[:login]).to eq(user.login)
        expect(json_body[:name]).to eq(user.name)
        expect(json_body[:expected_calories]).to eq(user.expected_calories)
      end

      it 'should inform the number of consumed calories of present day' do
        other_user = create(:user, :with_meals, meal_count: 3)
        sum = 0
        other_user.meals.each {|m| sum += m.calories}
        Meal.create(user: other_user, description: 'lunch', calories: 400, ate_at_time: 1.day.ago, ate_at_date: 1.day.ago)
        get '/api/profile', {}, auth_header(other_user.login, other_user.password)

        expect(json_body[:consumed_calories]).to eq(sum)
      end
    end
  end  
end