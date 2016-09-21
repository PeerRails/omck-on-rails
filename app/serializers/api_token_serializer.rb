# == Schema Information
#
# Table name: api_tokens
#
#  id         :integer          not null, primary key
#  secret     :string
#  user_id    :integer
#  expires_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ApiTokenSerializer < ActiveModel::Serializer
  attributes :id, :secret, :owner, :user_id, :expires_at, :created_at

  def owner
    User.select("name").find(object.user_id).name
  end

end
