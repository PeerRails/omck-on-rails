# == Schema Information
#
# Table name: api_tokens
#
#  id         :integer          not null, primary key
#  secret     :string
#  user_id    :integer
#  expires_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :api_token, class: ApiToken do
    secret Faker::Internet.password
    expires_at Faker::Date.forward(23)
  end
end
