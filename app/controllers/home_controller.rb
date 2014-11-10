class HomeController < ApplicationController
  before_filter :check_session, :except => [:index, :guest_room, :faq, :faq_irc]
  #before_filter :check_auth, :except => [:index, :guest_room, :remake_key, :change_key]
	def index
		#@session = auth
    #@tweet = Tweet.last
	end

  def cabinet
    redirect_to staff_url
  end

  def guest_room
    
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
