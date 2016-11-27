class UserOmniAuth
	def initialize(omniauth)
		@omniauth= omniauth
	end

	def login_with_twitter
		return false if @omniauth.nil?
		account = Account.where(provider: "twitter", provider_user_id: @omniauth[:uid]).first_or_create do |u|
			u.provider = "twitter"
			u.provider_user_id = @omniauth[:uid]
			u.username = @omniauth[:info][:nickname]
			u.fullname = @omniauth[:info][:name]
			u.client_id = Client.create( name: u.username,email: nil).id if u.client_id.nil?
			u.link = "https://twitter.com/#{u.username}"
		end
		account.update(username: @omniauth[:info][:nickname],
			       fullname: @omniauth[:info][:name],
			       profile_pic: @omniauth[:info][:image])
        account
	end
end
