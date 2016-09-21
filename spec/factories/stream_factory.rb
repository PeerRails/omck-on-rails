# == Schema Information
#
# Table name: streams
#
#  id         :integer          not null, primary key
#  key_id     :integer
#  user_id    :integer
#  channel_id :integer
#  game       :string
#  movie      :string
#  streamer   :string
#  ended_at   :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :stream, class: Stream do
    game Faker::Book.title
	movie Faker::Book.title
	streamer Faker::Name.name
	#ended_at Faker::Date.backward(14)
  end
end
