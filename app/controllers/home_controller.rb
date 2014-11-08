class HomeController < ApplicationController
  before_filter :check_session, :except => [:index, :guest_room, :faq, :faq_irc]
  #before_filter :check_auth, :except => [:index, :guest_room, :remake_key, :change_key]
	def index
		#@session = auth
    #@tweet = Tweet.last
	end

  def cabinet
    redirect_to staff_url
    @perm_stream = Key.present.find_by_uid(@session["id"])
    if !@perm_stream.nil? && @session["streamer"] == 1
      @create_key = Key.new(uid: @session["id"], streamer: @session["name"], game: "Boku No Pico", :guest => false, :expires => (Date.now + 2000) )
      @create_key.save
      @perm_stream = Key.find_by_uid(@session["id"]).present.last
    end
    if !@perm_stream.nil? || @session["gmod"] == "1"
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

  def faq

  end

  def faq_irc

  end

end
