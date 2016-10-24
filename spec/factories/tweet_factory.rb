# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  user_id    :integer          default(1), not null
#  comment    :text             not null
#  created_at :datetime
#  updated_at :datetime
#


FactoryGirl.define do
  factory :tweet, class: Tweet do
    comment {Faker::Lorem.characters(140)}
  end
end
