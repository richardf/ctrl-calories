require 'exceptions'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  respond_to :json
  responders :flash

  before_action :set_current_user, :authenticate_request

  rescue_from Exceptions::NotAuthenticatedError do
    render json: { error: 'Not Authorized' }, status: :unauthorized
  end
  
  rescue_from Exceptions::AuthenticationTimeoutError do
    render json: { error: 'Auth token is expired' }, status: :unauthorized
  end

  private

  def set_current_user
    if decoded_auth_token
      @current_user ||= User.find(decoded_auth_token[:user_id])
    end
  end

  def authenticate_request
    if !@current_user
      fail Exceptions::NotAuthenticatedError
    end
  end

  def decoded_auth_token
    @decoded_auth_token ||= AuthTokenEncoder.decode(http_auth_header_content)
  end

  # JWTs are stored in the Authorization header using this format:
  # Bearer somerandomstring.encoded-payload.anotherrandomstring
  def http_auth_header_content
    return @http_auth_header_content if defined? @http_auth_header_content
    @http_auth_header_content = begin
      if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      else
        nil
      end
    end
  end
end
