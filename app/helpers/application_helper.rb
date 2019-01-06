module ApplicationHelper
  def auth(bearer)
    err, response = RestClient.get(
        "#{ENV.fetch('API_SERVER') {'https://app-server.com'}}/users/api_auth",
        {Authorization: "Bearer #{bearer}"}) {|response, request, result, &block|
      case response.code
      when 200
        [false, response]
      else
        [true, response]
      end
    }
    json = JSON.parse response.body
    if not err
      user = User.find_or_create_by(external_key: json['user']['external_key'])
      user.update(name: json['user']['name']) if user.name != json['user']['name']
      user.update(avatar_url: json['user']['avatar_url']) if user.avatar_url != json['user']['avatar_url']
      user
    else
      nil
    end
  end
end
