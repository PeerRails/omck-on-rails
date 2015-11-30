class HomeController < ApplicationController
  def index
  end

  def cabinet
    if current_user
      # placeholder
      render 'login'
    else
      redirect_to home_login_url
    end
  end

  def login
    if current_user.nil?
      render 'login'
    else
      redirect_to home_url
    end
  end

  def admin
    if current_user
      # placeholder
      render 'login'
    else
      redirect_to home_login_url
    end
  end

  def faq
    render 'faq'
  end

  def params_key
    params.permit(:key)
  end
end
