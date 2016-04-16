class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    #Main
    alias_action :list_live, :list_all, :show, :to => :channels_view
    alias_action :live, :all, :show, :service, :to => :api_channel_view

    can :channels_view, Channel
    can :api_channel_view, Channel
    can :read, Tweet
    can :list, Video
    can :show, User
    can :videos, User

    if user.gmod?
      can :manage, :all
    elsif user.streamer?
      can :manage, Key, user_id: user.id, created_by: user.id
      can :create_guest, Key
      can :manage, Channel, :service => 'twitch'
      #can :update, User, :user_id => user.id
      can :remove, Video, :deleted => false, :user_id => user.id
      can :delete_by_tk, Video, :deleted => false, :user_id => user.id
      can :tweet, Tweet
    end
    unless user.id.nil?
        can :all, Key, user_id: user.id

        #API Tokens
        can :list, ApiToken
        can :show, ApiToken, user_id: user.id
        can :delete, ApiToken, user_id: user.id
        can :create, ApiToken, user_id: user.id
        can :expire, ApiToken, user_id: user.id
    end

  end
end
