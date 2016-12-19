class UserOmniAuth
  attr_accessor :provider, :omniauth
	def initialize(provider=self)
	  @provider = provider
	end

  # Authorize [Client] with [Account]
  # @params [OmniAuth]
  # @return [Client || Boolean]
  def authorize(omniauth=nil)
    return false if omniauth.nil?
    account = Account.where(provider: omniauth[:provider], provider_user_id: omniauth[:uid]).first_or_create do |u|
      u.provider = omniauth[:provider]
      u.provider_user_id = omniauth[:uid]
      u.username = omniauth[:info][:nickname]
      u.fullname = omniauth[:info][:fullname]
      u.client_id = Client.create_from_oauth(omniauth).id if u.client_id.nil?
    end
    @provider.omniauth = omniauth
    @provider.update(account)
    account.client
  end

  # Update [Account]
  # @param [Account]
  # @return [Boolean]
  # @raise NotImplementedError
  def update(account=nil)
    raise NotImplementedError
  end

end

