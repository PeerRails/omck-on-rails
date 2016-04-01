require 'rails_helper'

RSpec.describe Api::V1::KeysController, type: :controller do
  before do
    @streamer = create(:user, :streamer)
    sign_in @streamer
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

end
