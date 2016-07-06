require 'rails_helper'

describe VideoPolicy do
  subject { VideoPolicy }
  let(:user){build(:user, :guest)}
  let(:admin){build(:user, :admin)}
  let(:video){build(:video, user: user)}

  permissions :remove? do
    it "denies access if user is not admin or not owns" do
      user2 = create(:user)
      expect(subject).not_to permit(user, build(:video, user: user2))
    end

    it "allows creation of new Video if user is admin" do
      expect(subject).to permit(admin, video)
    end

    it "allows creation of new Video if user owns" do
      expect(subject).to permit(user, video)
    end
  end

  permissions :delete_by_tk? do
    it "denies access if user is not admin or not owns" do
      user2 = create(:user)
      expect(subject).not_to permit(user, build(:video, user: user2))
    end

    it "allows creation of new Video if user is admin" do
      expect(subject).to permit(admin, video)
    end

    it "allows creation of new Video if user owns" do
      expect(subject).to permit(user, video)
    end
  end

end
