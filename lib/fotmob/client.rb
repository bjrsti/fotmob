# frozen_string_literal: true

require "open-uri"
require "json"
require "uri"
require "timeout"

module Fotmob
  # Main client for interacting with the FotMob API
  class Client
    BASE_URL = "http://www.fotmob.com/api"
    DEFAULT_TIMEOUT = 10 # seconds

    attr_reader :timeout

    # Initialize a new FotMob API client
    #
    # @param timeout [Integer] Request timeout in seconds (default: 10)
    def initialize(timeout: DEFAULT_TIMEOUT)
      @timeout = timeout
    end

    # Get league/competition data
    #
    # @param league_id [String] The league ID
    # @return [Hash] League data with symbolized keys
    # @raise [Fotmob::Error] If the request fails
    def get_league(league_id)
      get("/leagues", id: league_id)
    end

    # Get matches for a specific date
    #
    # @param date [String] Date in YYYYMMDD format (e.g., "20221030")
    # @return [Hash] Match data with symbolized keys
    # @raise [Fotmob::Error] If the request fails
    def get_matches(date)
      get("/matches", date: date)
    end

    # Get detailed information about a specific match
    #
    # @param match_id [String] The match ID
    # @return [Hash] Match details with symbolized keys
    # @raise [Fotmob::Error] If the request fails
    def get_match_details(match_id)
      get("/matchDetails", matchId: match_id)
    end

    # Get player data and statistics
    #
    # @param player_id [String] The player ID
    # @return [Hash] Player data with symbolized keys
    # @raise [Fotmob::Error] If the request fails
    def get_player(player_id)
      get("/playerData", id: player_id)
    end

    # Get team data and statistics
    #
    # @param team_id [String] The team ID
    # @return [Hash] Team data with symbolized keys
    # @raise [Fotmob::Error] If the request fails
    def get_team(team_id)
      get("/teams", id: team_id)
    end

    private

    # Make a GET request to the FotMob API
    #
    # @param path [String] API endpoint path
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed JSON response with symbolized keys
    # @raise [Fotmob::Error] If the request fails
    def get(path, **params)
      uri = build_uri(path, params)
      response_body = fetch_with_timeout(uri)
      parse_json(response_body)
    rescue OpenURI::HTTPError => e
      handle_http_error(e)
    end

    # Build URI with query parameters
    def build_uri(path, params)
      # Use string concatenation like old version - URI.join doesn't work with /api/path
      url = BASE_URL + path
      uri = URI(url)
      uri.query = URI.encode_www_form(params) unless params.empty?
      uri
    end

    # Fetch URL with timeout using URI.open (avoids bot detection)
    def fetch_with_timeout(uri)
      Timeout.timeout(@timeout) do
        URI.open(uri.to_s).read
      end
    rescue Timeout::Error => e
      raise TimeoutError, "Request timed out after #{@timeout} seconds: #{e.message}"
    rescue OpenURI::HTTPError
      # Let HTTP errors bubble up to be handled by the caller
      raise
    rescue StandardError => e
      raise Error, "Network error: #{e.message}"
    end

    # Handle HTTP errors from URI.open
    def handle_http_error(error)
      status = error.io.status[0].to_i
      body = begin
        error.io.read
      rescue StandardError
        ""
      end

      case status
      when 404
        raise NotFoundError.new(
          "Resource not found",
          status_code: 404,
          response_body: body
        )
      when 429
        raise RateLimitError.new(
          "Rate limit exceeded. Please try again later.",
          status_code: 429,
          response_body: body
        )
      when 400..499
        raise APIError.new(
          "Client error: #{status}",
          status_code: status,
          response_body: body
        )
      when 500..599
        raise APIError.new(
          "Server error: #{status}",
          status_code: status,
          response_body: body
        )
      else
        raise APIError.new(
          "HTTP Error: #{status}",
          status_code: status,
          response_body: body
        )
      end
    end

    # Parse JSON response with symbolized keys
    def parse_json(body)
      JSON.parse(body, symbolize_names: true)
    rescue JSON::ParserError => e
      raise InvalidResponseError, "Failed to parse response: #{e.message}"
    end
  end
end
