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
# == JSON Scheme
#
#    {
#        "token":
#            {
#                "id":          Integer,
#                "secret":      String,
#                "owner":       String,
#                "user_id":     Integer,
#                "expires_at":  Date,
#                "created_at":  Date
#            }
#    }
# Array:
#    {
#        "tokens": [
#            {
#                <Token>
#            }
#        ]
#    }

class ApiTokenSerializer < ActiveModel::Serializer
  attributes :id, :secret, :owner, :user_id, :expires_at, :created_at

  # Returns Name of token's user
  # @return [String]
  def owner
    User.select("name").find(object.user_id).name
  end

end
