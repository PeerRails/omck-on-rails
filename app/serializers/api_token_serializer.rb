class ApiTokenSerializer < ActiveModel::Serializer
  attributes :id, :secret, :owner, :user_id, :expires_at, :created_at

  root :token

  def owner
    User.select("name").find(user_id).name
  end

end
