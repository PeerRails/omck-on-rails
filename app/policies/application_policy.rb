# General Policy for all nested Policies
class ApplicationPolicy
  attr_reader :user

  # Initialize policy's user and record
  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @record = record
  end

  # Return boolean value on user's gmod field
  # @return [Boolean]
  def admin?
    user.gmod == 1 ? true : false
  end

  # Return boolean value on user's streamer field
  # @return [Boolean]
  def streamer?
    user.streamer == 1 ? true : false
  end

  # Return boolean value on authorized user
  # @return [Boolean]
  def user?
    !user.nil?
  end

  # Return boolean value on user's ownage or record
  # @return [Boolean]
  def own?
    @user.id == @record.user_id
  end

end
