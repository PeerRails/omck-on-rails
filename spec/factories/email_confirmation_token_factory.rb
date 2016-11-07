# == Schema Information
#
# Table name: email_confirmation_tokens
#
#  id         :integer          not null, primary key
#  client_id  :integer
#  secret     :string
#  confirmed  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :ec_token, class: EmailConfirmationToken do
    confirmation false
    secret {Faker::Internet.password}
    client
  end
end
