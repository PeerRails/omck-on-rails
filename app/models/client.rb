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

    # Use FormValidator
    #validates_uniqueness_of :email
    #validates_uniqueness_of :nickname, case_sensitive: false
    #validates_uniqueness_of :email, case_sensitive: false, allow_blank: true
    #validates_presence_of :password, :nickname
    #validates :nickname, length: { in: 3..20 }#, format: { with: /\A[-_a-zA-Z0-9]\A/ }
    #validates :password, length: { in: 6..64 }

    attr_accessor :confirm_password, :last_ip

    before_create :encrypt_password
    #after_create :submit_data

    # Validate password
    # @ return Boolean
    #def password_nil?
      #self.password.nil?
    #end

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

    # Encrypt aka salt password before creation
    def encrypt_password
        password = PasswordHandler.new(self)
        password.salt_password
    end

    def self.create_from_oauth(omni)
        create!(nickname: omni[:info][:nickname], name: omni[:info][:fullname])
    end
end
