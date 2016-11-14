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

FactoryGirl.define do
	factory :client, class: Client do
		name {Faker::Name.name}
		email {Faker::Internet.email}
		password {Faker::Internet.password}
		remember_at {Faker::Date.forward(14)}
		last_login {DateTime.now}

		trait :viewer do
			admin false
			streamer false
			bot false
			verified {DateTime.now}
		end

		trait :admin do
			admin true
			verified {DateTime.now}
		end

		trait :streamer do
			streamer true
			verified {DateTime.now}
		end

		trait :bot do
			bot true
			verified {DateTime.now}
		end

	end
end
