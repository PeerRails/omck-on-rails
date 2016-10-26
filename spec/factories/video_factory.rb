# == Schema Information
#
# Table name: videos
#
#  id          :integer          not null, primary key
#  game        :string           default("Boku no Pico"), not null
#  user_id     :integer
#  key_id      :integer
#  youtube_id  :string
#  description :text             default("Boku no Pico")
#  token       :string           not null
#  path        :string
#  deleted     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  client_id   :integer
#  stream_id   :integer
#

FactoryGirl.define do
  factory :video, class: Video do
    game  {Faker::Book.title}
    description {Faker::Lorem.characters(42)}
    path  {Faker::Internet.url}
    deleted false
    stream
    key
    client
  end
end
