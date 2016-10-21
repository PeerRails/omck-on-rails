# == Schema Information
#
# Table name: streams
#
#  id         :integer          not null, primary key
#  key_id     :integer          not null
#  user_id    :integer          not null
#  channel_id :integer          not null
#  game       :string
#  movie      :string
#  streamer   :string
#  ended_at   :datetime
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
