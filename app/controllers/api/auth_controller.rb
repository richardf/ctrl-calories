class API::AuthController < ApplicationController

  skip_before_action :authenticate_request

  def authenticate
    login_param = params.require(:login)
    passwd_param = params.require(:password)
    user = User.find_by(login: login_param)

    if user && user.authenticate(passwd_param)
      render json: { auth_token: user.generate_auth_token }
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end
end
