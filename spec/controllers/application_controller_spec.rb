require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  before do
    @streamer = create(:user, :streamer)
    @gmod = create(:user, :mod)
    @admin = create(:user, :admin)
  end

end
