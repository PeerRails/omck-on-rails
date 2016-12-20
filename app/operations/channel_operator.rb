class ChannelOperator

  def self.get_channel(options={service: nil, channel: nil})
    channel = Channel.where(service: options[:service], channel: options[:channel]).first
    if channel.nil?
      ErrorResponse.new(channel_not_found, channel_not_found.message)
    else
      SuccessResponse.new(channel, "Channel found")
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
      error = Error.new({ message: "Channel data is invalid", data: channel.errors.messages, status: 400 })
      ErrorResponse.new(error, error.message)
    end
  end

  # Switch live status of channel
  # @params options [Hash]
  # @return [Response]
  def self.switch(options)
    res = get_channel({ service: options[:service], channel: options[:channel]})
    return ErrorResponse.new(channel_not_found, channel_not_found.message) if res.error?
    channel = res.data
    channel.toggle(:live)
    channel.save
    SuccessResponse.new(channel, "Success")
  end

  # Return Error for not_found
  # @return [Error]
  def self.channel_not_found
    Error.new({ status: 400,
                  data: Channel.none,
                  message: "Channel not found"})
  end

end
