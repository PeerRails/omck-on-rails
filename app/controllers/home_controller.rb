class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if user_signed_in?
      render 'home/user'
    else
      redirect_to new_user_session
    end
  end

  # def cabinet
  # end

  # def login
  # end

  # def faq
  # render 'faq'
  # end
end
