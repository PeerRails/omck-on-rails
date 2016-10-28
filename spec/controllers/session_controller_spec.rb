require 'rails_helper'

RSpec.describe SessionController, type: :controller do

    describe "login through email" do
        it "should remember client in session"
        it "should register and remember new client"
        it "should remake password for client"
        it "should change emails"
    end

    describe "login through external services" do
        it "should remember client who logged in through exserv"
        it "should register and remember client who logged in through exserv"
        it "should attach account from external service to client"
        it "should do some insane batshit"
    end

end
