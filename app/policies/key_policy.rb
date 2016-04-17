class KeyPolicy < ApplicationPolicy

  def list?
    Key.present.where(user_id: user.id).exists?
  end

  def create?
    admin? or streamer?
  end

  def create_guest?
    admin? or streamer?
  end

  def update?
    admin? or own? or invited?
  end

  def expire?
    admin? or own? or invited?
  end

  def regenerate?
    admin? or own? or invited?
  end

  def expire_guest?
    admin? or own? or invited?
  end

  def secret?
    own? or invited? or admin?
  end

  def own?
    user.id == key.user_id
  end

  def invited?
    key.guest && user.id == key.created_by
  end

  def key
    @record
  end

end
