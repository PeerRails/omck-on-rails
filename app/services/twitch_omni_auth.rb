class TwitchOmniAuth
  attr_accessor :omniauth

  # Update [Account]
  # @param [OmniAuth]
  # @return [Account]
  def update(account)
    account.update(username: @omniauth[:info][:nickname],
                  fullname: @omniauth[:info][:name],
                  profile_pic: @omniauth[:info][:image],
                  link: "https://twitch.tv/#{@omniauth[:info][:nickname]}")
  end
end
