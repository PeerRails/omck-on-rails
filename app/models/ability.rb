class Ability
  include CanCan::Ability

  def initialize(client)
    client ||= Client.new
=begin
    if client.admin?
      can :manage, :all
    elsif client.streamer?
      can :manage, :all
    elsif client.bot?
      can :manage, :all
    end

    unless client.id.nil?
      can :all, Key, client_id: client.id
      can :list, ApiToken
      can :show, ApiToken, client_id: client.id
      can :delete, ApiToken, client_id: client.id
      can :create, ApiToken, client_id: client.id
      can :expire, ApiToken, client_id: client.id
    end
=end
  end
end
