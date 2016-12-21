class ClientSerializer < ActiveModel::Serializer
  attributes :name, :email, :admin, :streamer, :bot, :accounts, :api_tokens, :created_at, :verified

  has_many :accounts

end
