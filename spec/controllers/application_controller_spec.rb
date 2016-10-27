require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

    describe "private" do
        let(:client){create(:client)}
        it "should have current_client" do
            allow(controller).to receive(:current_client).and_return(client)
            expect(current_client).not_to be nil
        end
    end

end
