class ChannelPolicy < ApplicationPolicy

  def create?
    admin? or streamer?
  end

  def update?
    admin? or streamer?
  end

  def remove?
    admin? or streamer?
  end

  def channel
    @record
  end

end
