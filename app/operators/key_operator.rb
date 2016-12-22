class KeyOperator

  # Return response with key
  #
  # @param client_id [Integer]
  # @return [Response]
  def self.get_key(client_id=nil)
    key = Key.where(client_id: client_id).where('expires > ?', DateTime.now).first
    if key.nil?
      ErrorResponse.new(key_not_found, key_not_found.message)
    else
      SuccessResponse.new(key, "Key found")
    end
  end

  # Update Key record
  #
  # @param options [Hash]
  # @option options [Integer] :client_id Client id
  # @option options [Hash] :data Options: game, movie, streamer
  # @return [Response]
  def self.update(options)
    key = get_key(options[:client_id])
    return ErrorResponse.new(key_not_found, key_not_found.message) if key.error?
    if key.data.update_attributes(options[:data])
      SuccessResponse.new(key.data, "Key updated!")
    else
      error = Error.new({ message: "Key data is invalid", data: key.data.errors.messages, status: 400 })
      ErrorResponse.new(error, error.message)
    end
  end

  # Create new Key record
  #
  # @param options [Hash]
  # @option options [Integer] :client_id Client id
  # @option options [String] :streamer Name of streamer
  # @option options [String] :game Name of game
  # @option options [String] :movie Name of movie
  # @return [Response]
  def self.create(options)
    existing_key = get_key(options[:client_id])
    # Should add client verification
    key = Key.new(options)
    if existing_key.error? && key.save
      SuccessResponse.new(key, "Key created!")
    else
      error = Error.new({ message: "Key data is invalid", data: key.errors.messages, status: 400 })
      ErrorResponse.new( error, error.message )
    end
  end

  # Expire target key
  #
  # @param client_id [Integer] Client id
  # @return [Response]
  def self.expire(client_id)
    key = get_key(client_id)
    return ErrorResponse.new(key_not_found, key_not_found.message) if key.error?
    key.data.update(expires: DateTime.now)
    SuccessResponse.new(key.data, "Key expired!")
  end

  # Expire old key and create new for client
  #
  # @param client_id [Integer] Client id
  # @return [Response]
  def self.regenerate(client_id)
    key = expire(client_id)
    return ErrorResponse.new(key_not_found, key_not_found.message) if key.error?
    new_key = create({ client_id: client_id,
                       game: key.data.game,
                       movie: key.data.movie,
                       streamer: key.data.streamer })
    SuccessResponse.new( new_key.data, "Key regenerated!" )
  end

  private
    def self.key_not_found
      Error.new({ status: 404,
                          data: Key.none,
                          message: "Key not found" })
    end

end

