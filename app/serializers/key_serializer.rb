class KeySerializer < ActiveModel::Serializer
  attributes :streamer, :movie, :game, :guest, :expires, :created_by, :created_by_name, :secret, :user_id

  def secret
    #raise self.key.inspect
    #self.guest == false ? self.key : nil
    "placeholder"
    #current_user.id == self.id ? self.key : "placeholder"
  end

  def created_by_name
    User.find(self.created_by).name || nil
  end
end
