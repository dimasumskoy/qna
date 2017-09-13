module OmniauthMacros
  def facebook_mock_auth_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123456',
      info: { email: 'test@qna.com' },
      credentials: { token: 'mock_token', secret: 'mock_secret' }
    })
  end

  def twitter_mock_auth_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '123456',
      info: { name: 'mock_user' },
      credentials: { token: 'mock_token', secret: 'mock_secret' },
    })
  end

  def twitter_mock_with_email
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '123456',
      info: { name: 'mock_user', email: 'test@qna.com' },
      credentials: { token: 'mock_token', secret: 'mock_secret' },
    })
  end
end