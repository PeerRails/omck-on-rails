class HomeController < ApplicationController
  before_filter :check_session, :except => [:index, :guest_room, :faq, :faq_irc]
  #before_filter :check_auth, :except => [:index, :guest_room, :remake_key, :change_key]
	def index
		@session = auth
    @tweet = Tweet.last
	end

  def cabinet
    if @session["streamer"] == "1" || @session["gmod"] == "1"
      @key = Key.new
      @keys = Key.present.where(guest: true)
      @users = User.where(streamer: true)
      @user_key = Key.where(uid: @session["id"]).last
      @tweet = Tweet.new
      @tweets = Tweet.last(10)
      @channel = Channel.new
      @channels = Channel.where(service: "twitch")
    else
      flash[:success] = "Добро пожаловать! Новые фичи для гостей скоро!"
      redirect_to root_url
    end
  end

  def guest_room
    @session = auth
    key = params.permit(:key)
    @user_key = Key.where(key: key["key"]).last
    if @user_key.nil?
      flash[:danger] = "Такого ключа нет! Номер напишите Пиру в личку"
      redirect_to root_url
    end
  end

  def generate_key
    return SecureRandom.uuid
  end


  def make_key
    @key = Key.new( params.require(:key).permit(:uid, :streamer, :game, :guest, :expires) )
    @key.key = generate_key

    if @key.guest?
      if @key.save
        flash[:success] = "Гостевой ключ создан! Выдайте #{@key.streamer} : #{@key.key}"
      else
        flash[:danger] = "Ошибка при регистрации ключа!"
      end
    else
      user = User.where(id: @key.uid).last
      key = Key.where(uid: @key.uid).last
      if user.nil?
        flash[:danger] = "Такого пользователя нет!"
      elsif !key.nil? && key.expires < DateTime.now
        flash[:danger] = "У пользователя уже есть ключ!"
      else
        if @key.save
          flash[:success] = "Ключ создан! Выдайте #{@key.streamer} : #{@key.key}"
        else
          flash[:danger] = "Ошибка создания ключа!"
        end
      end
    end
    redirect_to home_url
  end

  def change_key
      @new_key = params.require(:key).permit(:streamer, :game)
      @user_key = Key.where(uid: @session["id"]).last
      @user_key.streamer = @new_key["streamer"]
      @user_key.game = @new_key["game"]
      if @user_key.save
        flash[:success] = "Обновлено!"
      else
        flash[:danger] = "Ошибка обновления!"
      end
      redirect_to home_url
  end

  def remake_key
    key = params.permit(:key)
    @old_key = Key.where(key: key["key"]).last
    @old_key.expires = DateTime.now

    @new_key = Key.new(uid: @old_key.uid,streamer: @old_key.streamer,game: @old_key.game,movie: @old_key.movie,guest: @old_key.guest)
    @new_key.expires = DateTime.now + 2.years
    @new_key.key = generate_key

    if @new_key.save && @old_key.save
      flash[:success] = "Ключ пересоздан! Выдайте #{@new_key.streamer} : #{@new_key.key}"
    else
      flash[:danger] = "Ошибка создания ключа!"
    end
    if @new_key.guest?
      redirect_to guest_room_url(key["key"])
    else
      redirect_to home_url
    end

  end

  def tweet
    @input = params.require(:tweet).permit(:comment, :tipe)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_1"]
      config.consumer_secret     = ENV["TWITTER_2"]
      config.access_token        = ENV["TWITTER_3"]
      config.access_token_secret = ENV["TWITTER_4"]
    end
    @input["tipe"] = 1 if @input["tipe"].nil?
    if @input["tipe"] == 1
      text = "Идет проверка || " + @input["comment"]
    else
      text = @input["comment"]
    end
    @new_tweet = Tweet.new(author: @session["name"], comment: text, tipe: @input["tipe"], uid: @session["id"])
    if @new_tweet.save
      if text.empty?
        flash[:danger] = "Поле пустое, батенька"
      else
        client.update(text)
        flash[:success] = "Успешно послан твит!"
      end
    else
      flash[:danger] = "Ошибка :с"
    end
    redirect_to home_url

  end

  def faq

  end

  def faq_irc

  end

end
