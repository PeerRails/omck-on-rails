class TweetsController < ApplicationController
  before_filter :check_session

  def tweet

    @input = params.require(:tweet).permit(:comment, :tipe)
    @new_tweet = Tweet.new(author: @session["name"], comment: @input["comment"], tipe: @input["tipe"], uid: @session["id"])

    if @new_tweet.save
        flash[:success] = "Успешно послан твит!"
    else
      flash[:danger] = "Ошибка :с"
    end

    redirect_to home_url
  end

end
