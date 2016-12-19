require "rails_helper"

RSpec.describe SessionService do
  describe "" do
	  let(:session){Faker::Internet.password(10)}
	  before do
	    @client = create(:client)
	    @service = SessionService.new(@client)
	  end

	  it { expect{@service.attach_to_client(session)}.to change{Session.count}.by(1) }
	  it { expect(@service.destroy(nil)).to be false }
    it { expect(@service.destroy("")).to be false }
	  it { expect(@service.destroy("false session")).to be true }
	  it "should destroy existing session" do
	    @service.attach_to_client(session)
	    expect(@service.destroy(session)).to be true
	  end

  end
end
