class HomeController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    render 'home/index'
  end

  def admin
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
