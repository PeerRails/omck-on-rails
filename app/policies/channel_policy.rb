# Policy for API Key
class ChannelPolicy < ApplicationPolicy

  # Show permission for user to create new channel
  # @return [Boolean]
  def create?
    admin? or streamer?
  end

  # Show permission for user to update new channel
  # @return [Boolean]
  def update?
    admin? or streamer?
  end

  # Show permission for user to remove new channel
  # @return [Boolean]
  def remove?
    admin? or streamer?
  end

  # Define channel with record
  # @return [Channel]
  def channel
    @record
  end

end
