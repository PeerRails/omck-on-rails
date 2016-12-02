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
  end
end
