# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

module Fotmob
  # Main client for interacting with the FotMob API
  class Client
    BASE_URL = "https://www.fotmob.com/api/data"
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
      request = build_request(uri)
      response = execute_request(uri, request)

      handle_response(response)
    end

    # Build URI with query parameters
    def build_uri(path, params)
      uri = URI.join(BASE_URL, path)
      uri.query = URI.encode_www_form(params) unless params.empty?
      uri
    end

    # Build HTTP GET request with headers
    def build_request(uri)
      request = Net::HTTP::Get.new(uri)
      request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 " \
                              "(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
      request["Accept"] = "application/json"
      request["Accept-Language"] = "en-US,en;q=0.9"
      request["Referer"] = "https://www.fotmob.com/"
      request
    end

    # Execute the HTTP request with timeout and SSL
    def execute_request(uri, request)
      response = Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: uri.scheme == "https",
        read_timeout: @timeout,
        open_timeout: @timeout
      ) do |http|
        http.request(request)
      end

      # Follow redirects (up to 3 times)
      redirect_count = 0
      while response.is_a?(Net::HTTPRedirection) && redirect_count < 3
        redirect_count += 1
        location = response["location"]
        uri = URI(location)
        request = build_request(uri)

        response = Net::HTTP.start(
          uri.host,
          uri.port,
          use_ssl: uri.scheme == "https",
          read_timeout: @timeout,
          open_timeout: @timeout
        ) do |http|
          http.request(request)
        end
      end

      response
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      raise TimeoutError, "Request timed out after #{@timeout} seconds: #{e.message}"
    rescue StandardError => e
      raise Error, "Network error: #{e.message}"
    end

    # Handle the HTTP response and parse JSON
    def handle_response(response)
      case response.code.to_i
      when 200
        parse_json(response.body)
      when 404
        raise NotFoundError.new(
          "Resource not found",
          status_code: 404,
          response_body: response.body
        )
      when 429
        raise RateLimitError.new(
          "Rate limit exceeded. Please try again later.",
          status_code: 429,
          response_body: response.body
        )
      when 400..499
        raise APIError.new(
          "Client error: #{response.code} #{response.message}",
          status_code: response.code.to_i,
          response_body: response.body
        )
      when 500..599
        raise APIError.new(
          "Server error: #{response.code} #{response.message}",
          status_code: response.code.to_i,
          response_body: response.body
        )
      else
        raise APIError.new(
          "Unexpected response: #{response.code} #{response.message}",
          status_code: response.code.to_i,
          response_body: response.body
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
