require 'rails_helper'

RSpec.describe SignupForm do
  describe "validates" do
    it "nickname" do
      form = SignupForm.new(Client.new)
      expect(form.validate({nickname: nil}))
    end
  end
end
