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

    # Show [Session] of [nil] on expiration of session
    # @return [Session | nil]
    def self.expired?(session_id)
        session = Session.where(:session_id => session_id).first
        (session.nil? or session.expires > DateTime.now) ? session : nil
    end

end
