module Requests
  module JsonHelpers
    def json_body
      JSON.parse(response.body, symbolize_names: true)
    end
  end

  def auth_header(login, password)
	post '/api/auth', {login: login, password: password}
	token = json_body[:auth_token]
	{'Authorization' => "Bearer #{token}"}
  end
end