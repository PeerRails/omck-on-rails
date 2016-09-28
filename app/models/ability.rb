class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    alias_action :list_live, :list_all, :show, :to => :channels_view
    alias_action :live, :all, :show, :service, :to => :api_channel_view
    alias_action :last, :by_user, :show, :by_period, to: :stream_view
    alias_action :show, :list, :videos, :by_user, to: :user_view

    can :channels_view, Channel
    can :api_channel_view, Channel
    can :user_view, Tweet
    can :user_view, Video
    can :user_view, User
    can :stream_view, Stream

    if user.gmod?
      can :manage, :all
    elsif user.streamer?
      can :manage, Key, user_id: user.id, created_by: user.id
      can :create_guest, Key
      can :manage, Channel, :service => 'twitch'
      can :update, User, :id => user.id
      can :grant, User
      can :invite, User
      can :add, Video
      can :update, Video
      can :archive, Video, :deleted => false
      can :remove, Video, :deleted => false, :user_id => user.id
      can :delete_by_tk, Video, :deleted => false, :user_id => user.id
      can :post, Tweet
      can :delete, Tweet
      can :stop, Stream
    end

    unless user.id.nil?
      can :all, Key, user_id: user.id
      can :list, ApiToken
      can :show, ApiToken, user_id: user.id
      can :delete, ApiToken, user_id: user.id
      can :create, ApiToken, user_id: user.id
      can :expire, ApiToken, user_id: user.id
    end
  end
end
