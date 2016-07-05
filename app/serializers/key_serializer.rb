class KeySerializer < ActiveModel::Serializer
  attributes :id, :streamer, :movie, :game, :guest, :expires, :created_by, :created_by_name, :created_by_screen_name, :user_id

  def created_by_name
    User.find(self.created_by).name || nil
  end

  def created_by_screen_name
    User.find(self.created_by).screen_name || nil
  end

end