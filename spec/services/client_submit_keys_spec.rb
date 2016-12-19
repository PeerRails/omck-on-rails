require 'rails_helper'

RSpec.describe ClientSubmitKeys do

    describe "it should save client and submit/attach keys" do
        let(:client){ ClientSubmitKeys.new(build(:client)) }

        subject { lambda { client.save } }
        it { should change {Client.count}.by(1)}
        it { should change {Key.count}.by(1)}
        it { should change {ApiToken.count}.by(1)}

    end
end
