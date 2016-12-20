require 'rails_helper'

RSpec.describe Error do
  it "should initialize error" do
    error = Error.new({message: "message", data: nil, status: 404})
    expect(error.message).to eql("message")
    expect(error.data).to be nil
    expect(error.status).to eq(404)
  end
end

