# Policy for API Token
class ApiTokenPolicy < ApplicationPolicy

  # Show permission for user to create new token
  # @return [Boolean]
  def create?
    user?
  end

  # Show permission for user to list owned tokens
  # @return [Boolean]
  def list
    user.id == api_token.user_id
  end

  # Show permission for user to list all tokens. Should be admin
  # @return [Boolean]
  def list_all?
    admin?
  end

  # Show permission for user to expire owned token
  # @return [Boolean]
  def expire?
    user.id == api_token.user_id
  end

  # Define record for policy
  # @return [Token]
  def api_token
    @record
  end

end
