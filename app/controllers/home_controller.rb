class HomeController < ApplicationController
  def index
    render json: {user: current_user}
  end

  #def cabinet
  #end

  #def login
  #end

  #def admin
  #end

  #def faq
    #render 'faq'
  #end

end
