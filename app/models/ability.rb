class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    alias_action :list_live, :list_all, :show, :to => :channels_view

    can :channels_view, Channel
    can :read, Tweet
    can :list, Video
    can :show, User
    can :videos, User
    if user.streamer?
      can :manage, Key, :user_id => user.id
      can :manage, Channel, :service => 'twitch'
      can :update, User, :user_id => user.id
      can :manage, Video, :deleted => false, :user_id => user.id
      can :tweet, Tweet
    elsif user.gmod?
      can :manage, :all
    end
  end
end
