class PasswordHandler
    def initialize(client)
        @client = client
    end

    def salt_password
        @client.salt = BCrypt::Engine.generate_salt
        @client.password = BCrypt::Engine.hash_secret(@client.password, @client.salt)
        @client
    end

    def save
        @clien.save
    end

    def valid_password?(password)
        BCrypt::Engine.hash_secret(password, @client.salt) == @client.password
    end

end
