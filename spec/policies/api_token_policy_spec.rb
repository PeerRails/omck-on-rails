require 'rails_helper'

describe ApiTokenPolicy do
  subject { ApiTokenPolicy }
  let(:user){build(:user)}
  let(:admin){build(:user, :admin)}
  let(:apitoken){build(:api_token)}

  permissions :create? do
    it "denies access if user is not logged" do
      expect{subject.new(nil, ApiToken.new())}.to raise_error(Pundit::NotAuthorizedError)
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
    it "denies access if user is not logged" do
      expect{subject.new(nil, apitoken)}.to raise_error(Pundit::NotAuthorizedError)
    end
  end

end
