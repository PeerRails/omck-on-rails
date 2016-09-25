require 'rails_helper'

describe UserPolicy do
  subject { UserPolicy }
  let(:user){build(:user)}

  permissions :grant? do
    it "denies access if user is not admin" do
      expect(subject).not_to permit(User.new(gmod: 0), user.update(gmod: 1))
    end
  end

  permissions :invite? do
    it "denies invite if user is not admin or streamer" do
      expect(subject).not_to permit(User.new(gmod: 0), User.new)
    end
  end
end