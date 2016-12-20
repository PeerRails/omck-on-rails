require 'spec_helper'

RSpec.describe Response do

  describe "service" do
    it "should raise errors" do
      response = Response.new("", "")
      expect{response.success?}.to raise_error(NotImplementedError)
      expect{response.error?}.to raise_error(NotImplementedError)
    end
  end
end
