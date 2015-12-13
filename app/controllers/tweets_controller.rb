class TweetsController < ApplicationController
  before_action :auth

  def tweet
    @input = params.require(:tweet).permit(:comment, :own)
    @new_tweet = Tweet.new(comment: @input["comment"], user_id: current_user.id)

    if @input["own"] == "0"
      @new_tweet.comment = "Стрим на #omcktv || " + @new_tweet.comment
    end

    tweet = TClient.tclient.update( @new_tweet.comment )
    res = {}
    if @new_tweet.save
      res[:error] = nil
      res[:success] = "Успешно послан твит!"
    else
      res[:error] = true
      res[:message] = "Ошибка :с"
    end

    render json: res
  end

end
