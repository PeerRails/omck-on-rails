require 'rails_helper'

describe TweetPolicy do
  subject { TweetPolicy }
  let(:user){build(:user, :guest)}
  let(:admin){build(:user, :admin)}
  let(:tweet){build(:tweet, user: user)}

  permissions :tweet? do
    it "denies access if user is not admin or streamer" do
      expect(subject).not_to permit(user, Tweet.new())
    end

    it "allows tweeting if user is admin or streamer" do
      expect(subject).to permit(admin, Tweet.new())
    end
  end

end
