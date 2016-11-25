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
#  salt        :string
#

class Client < ApplicationRecord

  	has_one :key
  	has_many :tweets
  	has_many :videos
  	has_many :api_tokens
  	has_many :streams
    has_many :accounts

    before_create :salt_password
    validates_uniqueness_of :email
    #validates_uniqueness_of :nickname

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
        !self.verified.nil?
    end

    # Return current client's sessions
    def sessions
        Session.where(client_id: self.id)
                .where("expires > ?", DateTime.now)
    end

    # Add to client new stream key and new api token
    def submit_keys
        Key.create(client_id: self.id)
        ApiToken.create(client_id: self.id)
    end

    # Encrypt password
    def salt_password
        self.salt = BCrypt::Engine.generate_salt
        password = BCrypt::Engine.hash_secret(self.password, salt)
        self.password = password
    end

    # Match passwords
    def valid_password?(login_password)
        BCrypt::Engine.hash_secret(login_password, self.salt) == self.password
    end

end
