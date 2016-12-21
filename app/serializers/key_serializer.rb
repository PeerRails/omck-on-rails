# == Schema Information
#
# Table name: keys
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  key        :string           not null
#  game       :string           default("Boku no Pico"), not null
#  expires    :datetime         default(Thu, 01 Jan 2099 00:00:00 UTC +00:00), not null
#  streamer   :string           default("McDwarf")
#  created_at :datetime
#  updated_at :datetime
#  guest      :boolean          default(FALSE)
#  movie      :string           default("Boku Wa Tomodachi Ga Sekai")
#  created_by :integer
#  client_id  :integer
#


class KeySerializer < ActiveModel::Serializer
  attributes :streamer, :movie, :game, :expires, :client_id

  # Return formatted date of expire date
  # @return [String]
  def expires
    object.expires.strftime("%Y-%m-%d")
  end

end
