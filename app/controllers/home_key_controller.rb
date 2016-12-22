class HomeKeyController < ApplicationController

  # Get information about client
  def get_me
    render json: current_client
  end

  # Return key
  def get_key
    key = KeyOperator.get_key(current_client.id)
    render json: key.data, status: status(key)
  end

  # Return key secret
  def get_secret
    key = KeyOperator.get_key(current_client.id)
    secret = key.success? ? key.data.key : nil
    render json: { key: secret  }
  end

  # Update Client's Key object
  def update_key
    options = { client_id: current_client.id, data: key_params }
    key = KeyOperator.update(options)
    render json: key.data, status: status(key)
  end

  # Expire current key and create new
  def regenerate_key
    key = KeyOperator.regenerate(current_client.id)
    render json: key.data, status: status(key)
  end

  private
    def key_params
      params.require(:key).permit(:game, :movie, :streamer)
    end

    def status(res)
      res.success? ? 200 : res.data.status
    end
end
