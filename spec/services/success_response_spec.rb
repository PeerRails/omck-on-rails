require 'spec_helper'

RSpec.describe SuccessResponse do

  describe "service" do
    it "should return result" do
      response = SuccessResponse.new("", "")
      expect(response.success?).to be true
      expect(response.error?).to be nil
    end
  end
end
