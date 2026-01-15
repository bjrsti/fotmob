# frozen_string_literal: true

module Fotmob
  # Base error class for all Fotmob errors
  class Error < StandardError; end

  # Raised when the API returns an error response
  class APIError < Error
    attr_reader :status_code, :response_body

    def initialize(message, status_code: nil, response_body: nil)
      @status_code = status_code
      @response_body = response_body
      super(message)
    end
  end

  # Raised when a resource is not found (404)
  class NotFoundError < APIError; end

  # Raised when rate limit is exceeded (429)
  class RateLimitError < APIError; end

  # Raised when the request times out
  class TimeoutError < Error; end

  # Raised when the response cannot be parsed or is invalid
  class InvalidResponseError < Error; end
end
