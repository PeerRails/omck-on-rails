class ApplicationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def admin?
    @user.gmod?
  end
end
