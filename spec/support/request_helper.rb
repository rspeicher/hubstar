module RequestHelper
  def mock_auth(username)
    OmniAuth.config.mock_auth[:github] = {
      :credentials => {
        :token => "foobarbaz"
      },
      :extra => {
        :raw_info => {
          :login => username
        }
      }
    }
  end

  def login(user)
    mock_auth(user.username)
    get "/auth/github"
    follow_redirect!
  end

  def json(str)
    JSON.parse(str)
  end
end
