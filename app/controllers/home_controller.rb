class HomeController < ApplicationController
  def index
    render json: current_user
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
