# == Schema Information
#
# Table name: accounts
#
#  id               :integer          not null, primary key
#  provider         :string
#  provider_user_id :integer
#  username         :string
#  fullname         :string
#  link             :string
#  client_id        :integer
#  profile_pic      :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Account < ApplicationRecord
    belongs_to :client

    def self.login_with_twitter(omniauth)
        unless omniauth.nil?
          account = Account.where(provider: "twitter", provider_user_id: omniauth[:uid]).first_or_create do |u|
            u.provider = "twitter"
            u.provider_user_id = omniauth[:uid]
            u.username = omniauth[:info][:nickname]
            u.fullname = omniauth[:info][:name]
            u.client_id = Client.create(name: u.username, email: "#{u.username}@omck.ws").id if u.client_id.nil?
            u.link = "https://twitter.com/#{u.username}"
          end
          account.update(username: omniauth[:info][:nickname],
                        fullname: omniauth[:info][:name],
                        profile_pic: omniauth[:info][:image])
          return account
        else
          return nil
        end
    end
end
