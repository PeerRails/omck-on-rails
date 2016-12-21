class ChannelOperator

  # Return response with channel
  #
  # @param options [Hash]
  # @return [Response]
  def self.get_channel(options={service: nil, channel: nil})
    channel = Channel.where(service: options[:service], channel: options[:channel]).first unless options[:channel].nil?
    channel = Channel.where(service: options[:service]) if options[:channel].nil?
    if channel.nil?
      ErrorResponse.new(channel_not_found, channel_not_found.message)
    else
      SuccessResponse.new(channel, "Channel found")
    end
  end

  # Return response with collections of channels
  #
  # @param service [String]
  # @return [Response]
  def self.get_service(service)
    channels = Channel.where(service: service)
    SuccessResponse.new(channels, "Got channels")
  end

  # Routes show method to get_channel and get_service
  #
  # @param options [Hash]
  # @option options [String] :service
  # @option options [String] :channel
  def self.show(options)
    response = []
    if options[:channel].nil?
      get_service(options[:service])
    else
      get_channel(options)
    end
  end

  # Create Channel object
  #
  # @param options [Hash]
  # @return [Channel]
  def self.create(options)
    channel = Channel.new(options)
    if channel.save
      SuccessResponse.new(channel, "Success")
    else
      error = Error.new({ message: "Channel data is invalid", data: channel.errors.messages, status: 400 })
      ErrorResponse.new(error, error.message)
    end
  end

  # Update Channel object
  # @param options [Hash]
  # @return [Response]
  def self.update(options)
    channel = get_channel({service: options[:service], channel: options[:channel]})
    return ErrorResponse.new(channel_not_found, channel_not_found.message) if channel.error?
    if channel.data.update_attributes(options[:data])
      SuccessResponse.new(channel.data, "Success")
    else
      error = Error.new({ message: "Channel data is invalid", data: channel.data.errors.messages, status: 400 })
      ErrorResponse.new(error, error.message)
    end
  end

  # Switch live status of channel
  #
  # @param options [Hash]
  # @return [Response]
  def self.switch(options)
    res = get_channel({ service: options[:service], channel: options[:channel]})
    return ErrorResponse.new(channel_not_found, channel_not_found.message) if res.error?
    channel = res.data
    channel.toggle(:live)
    channel.save
    SuccessResponse.new(channel, "Success")
  end

  def self.destroy(options)
    channel = get_channel({ service: options[:service], channel: options[:channel] })
    return ErrorResponse.new(channel_not_found, channel_not_found.message) if channel.error?
    channel.data.destroy
    SuccessResponse.new(channel.data, "Success")
  end

  # Return Error for not_found
  # @return [Error]
  def self.channel_not_found
    Error.new({ status: 400,
                  data: Channel.none,
                  message: "Channel not found"})
  end

end
