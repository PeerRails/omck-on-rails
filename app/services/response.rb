class Response
  attr_reader :data, :message, :error

  # Initialize data with message
  #
  # @param data [Object] Object or collection of objects
  # @param message [String] Message with description
  def initialize(data, message)
    @data = data
    @message = message
  end

  # Return status of Response
  # Should be implemented in Error or Success classes
  # @raise NotImplementedError
  def success?
    raise NotImplementedError
  end

  # Return error status
  # Should be implemented in Error or Success classes
  # @raise NotImplementedError
  def error?
    raise NotImplementedError
  end

end

