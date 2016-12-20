class Error
  attr_reader :data, :message, :status, :error

  # Initialize new Error message
  # @param options [Hash] hash of parameters
  # @option options [String] :message message of error
  # @option options [Array] :data object or collection of objects
  # @option options [Integer] :status Error status code
  def initialize(options)
    @message = options[:message]
    @data = options[:data]
    @status = options[:status]
    @error = true
  end

end
