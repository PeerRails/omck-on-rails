require 'rails_helper'

RSpec.describe Api::V1::HdstatController, type: :controller do
  before do
    @hdgames = create(:channel, :hdchannel)
    @twitch = create(:channel, :twitchchannel)
    @user = create(:user, :admin, twitter_id: "222")
    @token = create(:api_token, user_id: @user.id)
    request.headers["HTTP_API_TOKEN"] = @token.secret
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe "GET #stats" do
    before do
        stub_request(:get, "http://localhost:8080/stats").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => '<?xml version="1.0" encoding="utf-8"?>
                                                <?xml-stylesheet type="text/xsl" href="stat.xsl" ?>
                                                <rtmp>
                                                <nginx_version>1.11.3</nginx_version>
                                                <nginx_rtmp_version>1.1.4</nginx_rtmp_version>
                                                <compiler>gcc 5.3.1 20160406 (Red Hat 5.3.1-6) (GCC) </compiler>
                                                <built>Aug 10 2016 17:30:04</built>
                                                <pid>20148</pid>
                                                <uptime>110612</uptime>
                                                <naccepted>1</naccepted>
                                                <bw_in>0</bw_in>
                                                <bytes_in>18212604</bytes_in>
                                                <bw_out>0</bw_out>
                                                <bytes_out>529</bytes_out>
                                                <server>
                                                <application>
                                                <name>hdgames</name>
                                                <live>
                                                <nclients>0</nclients>
                                                </live>
                                                </application>
                                                <application>
                                                <name>hdcinema</name>
                                                <live>
                                                <nclients>0</nclients>
                                                </live>
                                                </application>
                                                <application>
                                                <name>records</name>
                                                <live>
                                                <nclients>0</nclients>
                                                </live>
                                                </application>
                                                </server>
                                                </rtmp>', :headers => {})
        get :stats
    end
    let(:json){JSON.parse(response.body)}

    it {expect(json["error"]).to be nil}
    it {expect(json["rtmp"]).not_to be nil}
  end
end