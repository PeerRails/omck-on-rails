class PasswordHandler
    def initialize(client)
        @client = client
    end

    def salt_password
        @client.salt = BCrypt::Engine.generate_salt
        @client.password = BCrypt::Engine.hash_secret(@client.password, @client.salt)
        @client
    end

end
