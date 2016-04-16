class ApiTokensController < ApplicationController
  load_and_authorize_resource

  def list
    tokens = ApiToken.where(user_id: @current_user.id).where("expires_at > ?", DateTime.now)
    render json: tokens, root: "tokens"
  end

  def list_all
    tokens = ApiToken.where("expires_at > ?", DateTime.now)
    render json: tokens, root: "tokens"
  end

  def show
    token = ApiToken.find_by_user_id(params[:user_id])
    render json: token
  end

  def create
    token = ApiToken.new(user_id: params[:user_id])
    if token.save
      render json: token
    else
      render json: {error: true, message: token.errors}
    end
  end

  def expire
    token = ApiToken.find(params[:id])
    if token.update(expires_at: DateTime.now)
      render json: {error: nil, message: "Expired!"}
    else
      render json: {error: true, message: token.errors}
    end
  end
end
