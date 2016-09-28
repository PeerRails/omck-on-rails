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
#  expires    :date
#  session_id :string
#

FactoryGirl.define do
  factory :session, class: Session do
    guest false
    expires Faker::Date.forward(23)
    session_id Faker::Lorem.characters(16)
    ip Faker::Internet.ip_v4_address
    user
  end
end
