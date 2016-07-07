FactoryGirl.define do
  factory :stream, class: Stream do
    game Faker::Book.title
	movie Faker::Book.title
	streamer Faker::Name.name
	#ended_at Faker::Date.backward(14)
  end
end
