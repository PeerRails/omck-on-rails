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

        it "should check password" do
            client = password.salt_password
            expect(password.valid_password?(unsalted)).to be true
        end

	it "should save new client with hashed password" do
	    client = password.salt_password
	    expect{client.save}.to change{Client.count}.by(1)
	    expect(Client.last.password).not_to eq(unsalted)
	end

	it "should encrypt and save new client" do
	    client = password.encrypt
	    expect(client.password).not_to eq(unsalted)
	    expect(client.id).not_to be nil
	end
    end
end
