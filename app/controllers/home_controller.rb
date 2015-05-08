class HomeController < ApplicationController

	def index
    @current_user ||= User.select("users.*, sessions.ip, sessions.expires").joins(:sessions).where(sessions: {session_id: session[:session_id]}).last if session[:session_id].present?
	end

  def cabinet
    redirect_to staff_url
  end

  def guest
    @key = Key.new
    if params_key.present?
      key = params_key[:key]
      @user_key = Key.is_guest.where(key: key).last
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
