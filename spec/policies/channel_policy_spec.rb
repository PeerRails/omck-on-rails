require 'rails_helper'

describe ChannelPolicy do
  subject { ChannelPolicy }
  let(:user){build(:user, :guest)}
  let(:admin){build(:user, :admin)}
  let(:channel){build(:channel, :twitchchannel)}

  permissions :create? do
    it "denies access if user is not admin or streamer" do
      expect(subject).not_to permit(user, Channel.new())
    end

    it "allows creation of new channel if user is admin or streamer" do
      expect(subject).to permit(admin, Channel.new())
    end
  end

  permissions :update? do
    it "denies access if user is not admin" do
      expect(subject).not_to permit(user, Channel.new())
    end

    it "allows creation of new channel if user is admin" do
      expect(subject).to permit(admin, Channel.new())
    end
  end

  permissions :remove? do
    it "denies access if user is not admin" do
      expect(subject).not_to permit(user, Channel.new())
    end

    it "allows creation of new channel if user is admin" do
      expect(subject).to permit(admin, Channel.new())
    end
  end

end
