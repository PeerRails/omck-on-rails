require 'rails_helper'

describe KeyPolicy do
  subject { KeyPolicy }
  let(:user){build(:user, :guest)}
  let(:admin){build(:user, :admin)}
  let(:key){build(:key, user: user)}

  permissions :list? do
    it "denies access if no key" do
      expect(subject).not_to permit(user, key)
    end
  end

  permissions :create? do
    it "denies access if user is not admin or streamer" do
      expect(subject).not_to permit(user, Key.new())
    end

    it "allows creation of new Key if user is admin or streamer" do
      expect(subject).to permit(admin, Key.new())
    end
  end


  permissions :create_guest? do
    it "denies access if user is not admin or streamer" do
      expect(subject).not_to permit(user, Key.new())
    end

    it "allows creation of new Key if user is admin or streamer" do
      expect(subject).to permit(admin, Key.new())
    end
  end


  permissions :update? do
    it "denies access if user doesnt owns key" do
      another_user = create(:user)
      expect(subject).not_to permit(user, build(:key, user: another_user))
    end

    it "allows update of new Key if user owns key" do
      expect(subject).to permit(user, key)
    end

    it "allows update of new Key if user invited" do
      expect(subject).to permit(user, Key.new(guest: true, created_by: user.id, user_id: user.id))
    end

    it "allows update of new Key if user is admin" do
      expect(subject).to permit(admin, key)
    end
  end

end
