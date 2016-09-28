# == Schema Information
#
# Table name: keys
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  key        :string(255)      not null
#  game       :string(255)      default("Boku no Pico"), not null
#  expires    :date             default(Thu, 01 Jan 2099), not null
#  streamer   :string(255)      default("McDwarf")
#  created_at :datetime
#  updated_at :datetime
#  guest      :boolean          default(FALSE)
#  movie      :string(255)      default("Boku Wa Tomodachi Ga Sekai")
#  created_by :integer
#

FactoryGirl.define do
  factory :key, class: Key do
    key Faker::Internet.password
    game  Faker::Company.name
    movie Faker::Book.title
    expires Faker::Date.forward(23)
    streamer Faker::Name.name
    guest false
  end
end
