class HomeController < ApplicationController
  def index
    render json: { user: current_user }
  end

  def admin
    if user_signed_in?
      render 'home/admin/admin', layout: false
    else
      redirect_to new_user_session_path
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
