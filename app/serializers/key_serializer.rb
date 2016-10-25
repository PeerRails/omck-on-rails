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
  attributes :id, :streamer, :movie, :game, :guest, :expires, :created_by, :created_by_name, :created_by_screen_name, :user_id

  # Return name of the user who requested key
  # @return [String, Nil]
  def created_by_name
    User.find(object.created_by).name || nil
  end

  # Return screen name (@ twitter nickname) of the user who requested key
  # @return [String, Nil]
  def created_by_screen_name
    User.find(object.created_by).screen_name || nil
  end

  # Return formatted date of expire date
  # @return [String]
  def expires
    object.expires.strftime("%Y-%m-%d")
  end

end
