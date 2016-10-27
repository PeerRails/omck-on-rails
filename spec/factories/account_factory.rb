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

FactoryGirl.define do
	factory :account, class: Account do
		provider "twitter"
		username {Faker::Internet.user_name}
		fullname {Faker::Name.name}
		link {Faker::Internet.url}
		profile_pic {Faker::Placeholdit.image("50x50", 'png')}
		provider_user_id {Faker::Number.number}
		client

	end
end
