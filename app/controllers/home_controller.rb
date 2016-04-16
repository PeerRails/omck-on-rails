class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if user_signed_in?
      render 'home/user'
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
