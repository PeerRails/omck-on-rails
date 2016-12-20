class ErrorResponse < Response

  # Return status of Response
  # @return [Boolean]
  def success?
    false
  end

  # Return error status
  # @return [Boolean]
  def error?
    true
  end
end
