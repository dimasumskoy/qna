module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '123456',
      user_info: { name: 'mock_user' },
      credentials: { token: 'mock_token', secret: 'mock_secret' }
    })
  end
end