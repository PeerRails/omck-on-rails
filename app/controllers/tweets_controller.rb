class TweetsController < ApplicationController
  before_filter :auth

  def tweet

    @input = params.require(:tweet).permit(:comment, :own)
    @new_tweet = Tweet.new(comment: @input["comment"], own: @input["own"], user_id: current_user.id)

    if @new_tweet.save
      flash[:success] = "Успешно послан твит!"
    else
      flash[:danger] = "Ошибка :с"
    end

    redirect_to home_url
  end

end
