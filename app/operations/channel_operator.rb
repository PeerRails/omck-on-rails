class ChannelOperator

  def self.get_channel(options={service: nil, channel: nil})
    channel = Channel.where(service: options[:service], channel: options[:channel]).first
    if channel.nil?
      ErrorResponse.new(Channel.new, "Channel not found")
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
      ErrorResponse.new(channel.errors.messages, "Channel data is invalid")
    end
  end

  # Update Channel object
  # @param options [Hash]
  # @return [Channel]
  def self.update(options)
    channel = get_channel({service: options[:service], channel: options[:channel]})
    return ErrorResponse.new(Channel.new.errors.add(:channel, :not_found), "Channel not found") if channel.error?
    if channel.data.update_attributes(options[:data])
      SuccessResponse.new(channel.data, "Success")
    else
      ErrorResponse.new(channel.errors.messages, "Channel data is invalid")
    end
  end

  def self.switch(options)
    res = get_channel({ service: options[:service], channel: options[:channel]})
    return ErrorResponse.new(Channel.new.errors.add(:channel, :not_found), "Channel not found") if res.error?
    channel = res.data
    channel.toggle(:live)
    channel.save
    SuccessResponse.new(channel, "Success")
  end
end
