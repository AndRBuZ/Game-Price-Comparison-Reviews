class OauthAuthorization
  def initialize(access_token)
    @access_token = access_token
  end

  def call
    oauth_account = OauthAccount.find_by(uid: @access_token.uid, provider: @access_token.provider)
    p "!!! #{oauth_account.inspect}"
    return oauth_account.user if oauth_account

    if @access_token.info.email
      user = create_user(@access_token.info.email)
      create_oauth_account(user)
    else
      user = create_user(generate_temp_email)
      create_oauth_account(user)
    end
    user
  end

  private

  def create_oauth_account(user)
    OauthAccount.create(
      uid: @access_token.uid,
      provider: @access_token.provider,
      user_id: user.id
    )
  end

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
