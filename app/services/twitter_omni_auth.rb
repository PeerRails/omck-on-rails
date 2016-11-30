class TwitterOmniAuth
  attr_accessor :omniauth

  # Update [Account]
  # @params [OmniAuth]
  # @return [Account]
  def update(account)
    account.update(username: @omniauth[:info][:nickname],
                  fullname: @omniauth[:info][:name],
                  profile_pic: @omniauth[:info][:image],
                  link: @omniauth[:info][:urls][:Twitter])
  end
end
