class ClientSubmitKeys
    def initialize(client)
        @client = client
    end

    def save
        @client.save && submit_keys
    end

    private

        def submit_keys
            Key.create(client_id: @client.id)
            ApiToken.create(client_id: @client.id)
        end
end
