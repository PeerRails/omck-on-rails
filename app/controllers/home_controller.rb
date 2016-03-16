class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if user_signed_in?
      render 'home/user'
    else
      respond_to do |format|
        format.json { render json: {error: true, message: "You must log in to continue"}, status: 403 }
        format.html redirect_to new_user_session
      end
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
