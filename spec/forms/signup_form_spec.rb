require 'rails_helper'

RSpec.describe SignupForm do
  describe "validates" do
    let(:valid_signup){{nickname: "nickname", password: "123456", confirm_password: "123456"}}
    let(:not_match){{nickname: "nickname", password: "123456", confirm_password: "1"}}
    it "valid form" do
      form = SignupForm.new(valid_signup)
      expect(form.valid?).to be true
    end
    it "invalid form" do
      form = SignupForm.new(not_match)
      expect(form.valid?).to be false
    end

    it "duplicate nickname" do
      create(:client, nickname: "nickname")
      form = SignupForm.new(valid_signup)
      expect(form.valid?).to be false
    end

    it "duplicate email" do
      create(:client, email: "nickname@localhost")
      form = SignupForm.new(valid_signup)
      form.email = "nickname@localhost"
      expect(form.valid?).to be false
    end

  end

  describe "registers" do
    it "valid form" do
      form = SignupForm.new(nickname: "valid", password: "123456", confirm_password: "123456")
      expect{form.signup}.to change{Client.count}.by(1)
    end

    it "invalid form and returns errors" do
      form = SignupForm.new(nickname: "invalid", password: "123", confirm_password: "123")
      expect{form.signup}.to change{Client.count}.by(0)
      expect(form.errors.messages.empty?).to be false
    end
  end
end
