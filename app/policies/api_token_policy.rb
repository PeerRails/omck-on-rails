class ApiTokenPolicy < ApplicationPolicy

  def create?
    user?
  end

  def list
    user.id == api_token.user_id
  end

  def list_all?
    admin?
  end

  def expire?
    user.id == api_token.user_id
  end

  def api_token
    @record
  end

end
