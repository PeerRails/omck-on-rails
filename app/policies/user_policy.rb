class UserPolicy < ApplicationPolicy

  def grant?
    admin?
  end

  def invite?
    admin? or (user.id != user_record.id and streamer?)
  end

  def user_record
    @record
  end

end
