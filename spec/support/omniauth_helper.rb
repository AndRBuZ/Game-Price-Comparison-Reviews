module OmniAuthHelpers
  def mock_auth_hash(provider)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      provider: provider,
      uid: '123545',
      info: {
        name: 'John Doe'
      }
    })
  end
end
