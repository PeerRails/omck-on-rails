# == Schema Information
#
# Table name: keys
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  key        :string(255)      not null
#  game       :string(255)      default("Boku no Pico"), not null
#  expires    :date             default(Thu, 01 Jan 2099), not null
#  streamer   :string(255)      default("McDwarf")
#  created_at :datetime
#  updated_at :datetime
#  guest      :boolean          default(FALSE)
#  movie      :string(255)      default("Boku Wa Tomodachi Ga Sekai")
#  created_by :integer
#

class KeySerializer < ActiveModel::Serializer
  attributes :id, :streamer, :movie, :game, :guest, :expires, :created_by, :created_by_name, :created_by_screen_name, :user_id

  def created_by_name
    User.find(object.created_by).name || nil
  end

  def created_by_screen_name
    User.find(object.created_by).screen_name || nil
  end

end
