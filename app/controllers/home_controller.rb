class HomeController < ApplicationController
  before_action :authenticate_user!

  def admin
    if user_signed_in?
      render 'home/user'
    end
  end

end
