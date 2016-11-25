require 'rails_helper'

RSpec.describe PasswordHandler do

    describe "salt factory" do
        let(:unsalted) {"salt_Factory"}
        let(:password){ PasswordHandler.new(build(:client, password: unsalted)) }

        it "should salt password" do
            client = password.salt_password
            expect(client.salt).not_to be nil
            expect(BCrypt::Engine.hash_secret(unsalted, client.salt)).to eq(client.password)
        end
    end
end