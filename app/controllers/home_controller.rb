class HomeController < ApplicationController
  before_filter :auth, :except => [:index, :guest_room, :faq, :faq_irc]
  #before_filter :check_auth, :except => [:index, :guest_room, :remake_key, :change_key]
	def index
		#@session = auth
    #@tweet = Tweet.last
	end

  def cabinet
    redirect_to staff_url
  end

  def guest
    @key = Key.new
    if params_key.present?
      key = params_key[:key]
      @user_key = Key.where(key: key).last
      if @user_key.nil?
        flash[:danger] = "Такого ключа нет! Номер напишите Пиру в личку"
      end
    end

  end

  def faq

  end

  def faq_irc

  end

  def params_key
    params.permit(:key)
  end

end
