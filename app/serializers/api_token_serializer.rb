class ApiTokenSerializer < ActiveModel::Serializer
  attributes :id, :secret, :owner, :user_id, :expires_at, :created_at

  def owner
    User.select("name").find(object.user_id).name
  end

end
