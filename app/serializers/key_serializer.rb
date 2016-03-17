class KeySerializer < ActiveModel::Serializer
  attributes :guest_id, :streamer, :movie, :game, :guest, :expires, :created_by, :created_by_name, :secret, :user_id

  def guest_id
    self.guest == false ? nil : self.id
  end

  def secret
    #raise self.key.inspect
    #self.guest == false ? self.key : nil
    "placeholder"
  end

  def created_by_name
    User.find(self.created_by).name || nil
  end
end
