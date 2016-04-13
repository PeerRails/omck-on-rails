class ApiTokenSerializer < ActiveModel::Serializer
  attributes :id, :secret, :user_id, :expires_at, :created_at

  root :token

end
