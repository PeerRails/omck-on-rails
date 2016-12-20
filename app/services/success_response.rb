class SuccessResponse < Response

  # Return status of Response
  # @return [Boolean]
  def success?
    true
  end

  # Return error status
  # @return [Boolean]
  def error?
    nil
  end
end

