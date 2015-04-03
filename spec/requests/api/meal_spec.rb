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
end