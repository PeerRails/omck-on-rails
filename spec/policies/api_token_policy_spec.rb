require 'rails_helper'

describe ApiTokenPolicy do
  subject { ApiTokenPolicy }
  let(:user){build(:user)}
  let(:admin){build(:user, :admin)}
  let(:apitoken){build(:api_token, user: user)}

  permissions :create? do
    it "allows to create new token if user is logged" do
      expect(subject).to permit(user, ApiToken.new())
    end
  end

  permissions :list do
    it "lists api tokens with user id" do
      expect(subject).to permit(user, apitoken)
    end
  end

  permissions :list_all? do
    it "lists all api tokens if user is admin" do
      expect(subject).to permit(admin, apitoken)
    end
  end

  permissions :expire? do
    it "allows to expire old token if user is logged and owns it" do
      expect(subject).to permit(user, apitoken)
    end

    it "denies access if user doesnt own it" do
      user2 = create(:user)
      expect(subject).not_to permit(user, build(:api_token, user: user2))
    end
  end

end
