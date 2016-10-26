# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  ip         :inet
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  guest      :boolean          default(FALSE)
#  expires    :datetime
#  session_id :string
#  client_id  :integer
#




class Session < ApplicationRecord
    belongs_to :client
    validates :session_id, presence: true, uniqueness: true

    # Add session attached to client
    # @params client [Client] Client object
    # @params session_id [String] String with encrypted unique session identificator
    # @return [Boolean] true if saved or false on reject
    def self.create_session(client, session_id)
        session = Session.create(:client_id => client.id,
              :session_id => session_id,
              :expires => client.remember_at,
              :guest => false )
        session.save!
    end

    # Detach session string id from client (logout)
    # @params session_id [String] String with encrypted unique session identificator
    # @return [Boolean] true if saved or false on reject
    def self.destroy_session(session_id)
        Session.find_by(:session_id => session_id)
              .update(:expires => DateTime.now)
    end

end
