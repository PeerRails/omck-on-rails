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
#


class Video < ActiveRecord::Base
  belongs_to :key
  belongs_to :user

  scope :deleted, -> { where(deleted: true) }
  scope :list, -> { select("token, game, deleted, description, path, user_id, key_id, created_at, updated_at").where(deleted: false) }

  before_create :create_token

  def create_token
    self.token = SecureRandom.urlsafe_base64(6)
  end

end
