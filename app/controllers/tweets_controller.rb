class TweetsController < ApplicationController
  load_and_authorize_resource

  def tweet
    @input = params.require(:tweet).permit(:comment, :own)
    @new_tweet = Tweet.new(comment: @input["comment"], user_id: current_user.id)

    if @input["own"] == "0" || @input["own"] == "false"
      @new_tweet.comment = "Стрим на #omcktv || " + @new_tweet.comment
    end

    res = {}
    if @new_tweet.save
      tclient.update( @new_tweet.comment )
      res[:error] = nil
      res[:success] = "Успешно послан твит!"
      res[:text] = @new_tweet.comment
      res[:user] = @new_tweet.user.name
    else
      res[:error] = true
      res[:message] = @new_tweet.errors.full_messages
    end

    render json: res
  end

end
