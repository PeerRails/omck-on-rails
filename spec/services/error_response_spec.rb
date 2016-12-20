require 'spec_helper'

RSpec.describe ErrorResponse do

  describe "service" do
    it "should return result" do
      response = ErrorResponse.new("", "")
      expect(response.success?).to be false
      expect(response.error?).to be true
    end
  end
end
