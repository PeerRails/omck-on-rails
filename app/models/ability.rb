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
    if user.gmod?
      can :manage, :all
    elsif user.streamer?
      can :manage, Key, :user_id => user.id
      can :manage, Key, :created_by => user.id
      can :create_guest, Key
      can :manage, Channel, :service => 'twitch'
      can :update, User, :user_id => user.id
      can :remove, Video, :deleted => false, :user_id => user.id
      can :delete_by_tk, Video, :deleted => false, :user_id => user.id
      can :tweet, Tweet
    end
  end
end
