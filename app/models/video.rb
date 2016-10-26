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

class Video < ApplicationRecord
  belongs_to :key
  belongs_to :client
  belongs_to :stream

  before_create :create_token

  # Create unique urlsafe token for video
  def create_token
    self.token = SecureRandom.urlsafe_base64(14)
  end

end
