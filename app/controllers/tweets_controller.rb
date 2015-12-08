class TweetsController < ApplicationController

  def tweet
    @input = params.require(:tweet).permit(:comment, :own)
    @new_tweet = Tweet.new(comment: @input["comment"], user_id: current_user.id)

    if @input["own"] == "0"
      @new_tweet.comment = "Стрим на #omcktv || " + @new_tweet.comment
    end

    TClient.tclient.update( @new_tweet.comment )

    if @new_tweet.save
      flash[:success] = "Успешно послан твит!"
    else
      flash[:danger] = "Ошибка :с"
    end

    redirect_to home_url
  end

  def last_tweets
    
  end

end
