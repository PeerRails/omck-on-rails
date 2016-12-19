class TwitterOmniAuth
  attr_accessor :omniauth

  # Update [Account]
  # @param [OmniAuth]
  # @return [Account]
  def update(account)
    account.update(username: @omniauth[:info][:nickname],
                  fullname: @omniauth[:info][:name],
                  profile_pic: @omniauth[:info][:image],
                  link: @omniauth[:info][:urls][:Twitter])
  end

  # Set omniauth variable
  # @param [OmniAuth]
  # @return [OmniAuth]
  #def set_omniauth(omniauth=nil)
    #@omniauth = omniauth
  #end
end
