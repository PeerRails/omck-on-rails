class HomeController < ApplicationController

  # Get information about client
  #
  # @return [Client]
  def get_me
    render json: current_client
  end

  # Return key secret
  #
  # @return [String]
  def get_secret
    key = Key.select(:key).where(client_id: current_client.id).where('expires > ?', DateTime.now).first || Key.none
    render json: { key: key.key }
  end

  # Update Client's Key object
  #
  # @param game [String]
  # @param movie [String]
  # @param streamer [String]
  def update_key
    key = Key.where(client_id: current_client.id).where('expires > ?', DateTime.now).first || Key.none
    key.update_attributes(key_params)
    render json: key
  end

  # Expire current key and create new
  #
  # @return [Key]
  def regenerate_key
    key = Key.where(client_id: current_client.id).where('expires > ?', DateTime.now).first || Key.none
    key.update_attributes({expires: DateTime.now})
    new_key = Key.create( client_id: key.client_id, game: key.game, movie: key.movie, streamer: key.streamer)
    render json: new_key

  end

  private
    def key_params
      params.require(:key).permit(:game, :movie, :streamer)
    end
end
