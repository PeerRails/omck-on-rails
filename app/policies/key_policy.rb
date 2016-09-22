# Policy for API Key
class KeyPolicy < ApplicationPolicy

  # Show permission for user to list owned Key
  # @return [Boolean]
  def list?
    Key.present.where(user_id: user.id).exists?
  end

  # Show permission for user to create new key
  # @return [Boolean]
  def create?
    admin? or streamer?
  end

  # Show permission for user to create new guest key
  # @return [Boolean]
  def create_guest?
    admin? or streamer?
  end

  # Show permission for user to update required key
  # @return [Boolean]
  def update?
    admin? or own? or invited?
  end

  # Show permission for user to expire key
  # @return [Boolean]
  def expire?
    admin? or own? or invited?
  end

  # Show permission for user to regenerate key
  # @return [Boolean]
  def regenerate?
    admin? or own? or invited?
  end

  # Show permission for user to expire own guest key
  # @return [Boolean]
  def expire_guest?
    admin? or own? or invited?
  end

  # Show permission for user to show key secret
  # @return [Boolean]
  def secret?
    own? or invited? or admin?
  end

  # Show key attachment to user
  # @return [Boolean]
  def invited?
    key.guest && user.id == key.created_by
  end

  # Define record
  # @return [Key]
  def key
    @record
  end

end
