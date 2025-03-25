class OauthAuthorization
  def initialize(access_token)
    @access_token = access_token
  end

  def call
    oauth_account = OauthAccount.find_or_create_by(
      uid: @access_token.uid,
      provider: @access_token.provider
    ) do |account|
      email = @access_token.info.email || generate_temp_email
      account.user = create_user(email)
    end
    oauth_account.user
  end

  private

  def create_user(email)
    User.create(
      nickname: @access_token.info.name,
      email: email,
      password: SecureRandom.hex
    )
  end

  def generate_temp_email
    "#{@access_token.provider}_#{@access_token.uid}@example.com"
  end
end
