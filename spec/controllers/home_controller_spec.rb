require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  before do
    @client = create(:client)
    @session = create(:session, client: @client)
    @session_id = @session.session_id
    @account = create(:account, client: @client)
    @key = create(:key, client: @client)
  end

end
