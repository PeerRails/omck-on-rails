module TClient
   class << self
       def tclient
         tclient = Twitter::REST::Client.new do |config|
           config.consumer_key        = ENV["TICKET_1"]
           config.consumer_secret     = ENV["TICKET_2"]
           config.access_token        = ENV["TICKET_3"]
           config.access_token_secret = ENV["TICKET_4"]
         end

       end
  end
end
