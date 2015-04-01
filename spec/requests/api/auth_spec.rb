require 'rails_helper'

describe "Authentication API",  type: :request do
  subject {create(:user)}

  context 'with valid credentials' do
    before(:each) {post '/api/auth', {login: subject.login, password: 'foobar'}}

    it 'should return status ok' do
      expect(response).to have_http_status :ok
    end

    it 'should return auth token' do
      expect(json[:auth_token].size).to be > 0
    end

    it 'should not return error' do
      expect(json[:error]).to be nil
    end
  end

  context 'with invalid credentials' do
    it 'should return status not authorized if login is invalid' do
      post '/api/auth', {login: 'invalid_login', password: 'foobar'}
      expect(response).to have_http_status :unauthorized
      expect(json[:error]).to eq('Invalid username or password')
    end

    it 'should return status not authorized if password is invalid' do
      post '/api/auth', {login: subject.login, password: 'wrong_password'}
      expect(response).to have_http_status :unauthorized
    end

    it 'should return error message' do
      post '/api/auth', {login: 'invalid_login', password: 'foobar'}
      expect(json[:error]).to eq('Invalid username or password')
    end

    it 'should not have auth token' do
      post '/api/auth', {login: 'invalid_login', password: 'foobar'}
      expect(json[:auth_token]).to be nil
    end
  end
end