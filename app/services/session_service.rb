class SessionService

    # Initialize service object
    # @param [Client]
    def initialize(client)
        @client = client || Client.new
    end

    # Add session attached to client
    # @params session_id [String] String with encrypted unique session identificator
    # @return [Boolean] true if saved or false on reject
    def attach_to_client(session_id)
        Session.create(:client_id => @client.id,
              :session_id => session_id,
              :expires => @client.remember_at,
              :ip => @client.last_ip
              )
    end

    # Detach session string id from client (logout)
    # @params session_id [String] String with encrypted unique session identificator
    # @return [Boolean] true if saved or false on reject
    def destroy(session_id)
        return false if session_id.nil? || session_id.empty?
        session = Session.where(:session_id => session_id, client_id: @client.id).first
      	unless session.nil?
            session.update(:expires => DateTime.now)
        else
            true
        end
    end
end
