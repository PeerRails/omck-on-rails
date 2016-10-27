# == Schema Information
#
# Table name: clients
#
#  id          :integer          not null, primary key
#  name        :string           default("Dwarf")
#  email       :string
#  password    :string
#  admin       :boolean          default(FALSE)
#  streamer    :boolean          default(FALSE)
#  bot         :boolean          default(FALSE)
#  verified    :datetime
#  remember_at :datetime
#  last_login  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Client < ApplicationRecord

  	has_one :key
  	has_many :tweets
  	has_many :videos
  	has_many :api_tokens
  	has_many :streams
    has_many :accounts

    validate :validate_values, on: [:create, :update]
    after_create :pair_key_and_token

    # Validate values on create and update actions
    # @params [Client]
    def validate_values
        errors.add(:email, message: "is already registered") unless Client.find_by_email(self.email).nil?
        errors.add(:name, message: "is blank") if self.name.nil?
    end

    # Check client's role
    # @return Boolean
    def admin?
        self.admin
    end

    # Check client's role
    # @return Boolean
    def streamer?
        self.streamer
    end

    # Check client's role
	# @return Boolean
    def bot?
        self.bot
    end

    # Check clie`nt's role
	# @return Boolean
    def viewer?
        !self.admin? || !self.streamer? || !self.bot?
    end

    # Check client's verification status
	# @return Boolean
    def verified?
        self.verified.nil?
    end

    # Return current client's sessions
    def sessions
        Session.where(client_id: self.id)
                .where("expires > ?", DateTime.now)
    end

    # Add to client new stream key and new api token
    def pair_key_and_token
        Key.create(client_id: self.id)
        ApiToken.create(client_id: self.id)
    end

end
