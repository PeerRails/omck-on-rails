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

end
