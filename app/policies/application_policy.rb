class ApplicationPolicy
  attr_reader :user

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @record = record
  end

  def admin?
    user.gmod == 1 ? true : false
  end

  def streamer?
    user.streamer == 1 ? true : false
  end

  def user?
    !user.nil?
  end

end
