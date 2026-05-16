# frozen_string_literal: true

require "open-uri"
require "json"
require "uri"
require "timeout"

module Fotmob
  class Client
    BASE_URL = "https://www.fotmob.com/api/data"
    DEFAULT_TIMEOUT = 10
    DEFAULT_TIMEZONE = "Europe/Paris"
    UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 " \
         "(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

    attr_reader :timeout, :timezone

    def initialize(timeout: DEFAULT_TIMEOUT, timezone: DEFAULT_TIMEZONE)
      @timeout = timeout
      @timezone = timezone
    end

    def get_league(league_id)
      get("/leagues", id: league_id, tab: "overview")
    end

    def get_matches(date)
      get("/matches", date: date, timezone: @timezone)
    end

    # Returns pageProps with keys: general, header, content (stats, lineup, etc.)
    # Resolves the match slug via a redirect, with automatic buildId refresh on stale deploys.
    def get_match_details(match_id)
      @retried_build_id = false
      build_id = fetch_build_id
      slug = fetch_match_slug(match_id, build_id)
      body = fetch_with_timeout(URI("https://www.fotmob.com/_next/data/#{build_id}/matches/#{slug}.json"))
      parse_json(body)[:pageProps]
    rescue OpenURI::HTTPError => e
      handle_http_error(e)
    end

    def get_team(team_id)
      get("/teams", id: team_id)
    end

    private

    def get(path, **params)
      uri = build_uri(path, params)
      response_body = fetch_with_timeout(uri)
      parse_json(response_body)
    rescue OpenURI::HTTPError => e
      handle_http_error(e)
    end

    def fetch_build_id(force: false)
      @fetch_build_id = nil if force
      @fetch_build_id ||= begin
        html = fetch_with_timeout(URI("https://www.fotmob.com/"))
        html.match(/"buildId":"([^"]+)"/)[1]
      end
    end

    def fetch_match_slug(match_id, build_id)
      redirect_body = fetch_with_timeout(
        URI("https://www.fotmob.com/_next/data/#{build_id}/match/#{match_id}.json")
      )
      redirect = parse_json(redirect_body).dig(:pageProps, :__N_REDIRECT)
      raise NotFoundError.new("Match #{match_id} not found", status_code: 404) unless redirect

      redirect.sub(%r{^/matches/}, "").sub(/#.*$/, "")
    rescue OpenURI::HTTPError => e
      raise unless e.io.status[0].to_i == 404 && !@retried_build_id

      @retried_build_id = true
      fetch_match_slug(match_id, fetch_build_id(force: true))
    end

    def build_uri(path, params)
      uri = URI(BASE_URL + path)
      uri.query = URI.encode_www_form(params) unless params.empty?
      uri
    end

    def fetch_with_timeout(uri)
      Timeout.timeout(@timeout) do
        URI.open(uri.to_s, "User-Agent" => UA).read
      end
    rescue Timeout::Error => e
      raise TimeoutError, "Request timed out after #{@timeout} seconds: #{e.message}"
    rescue OpenURI::HTTPError
      raise
    rescue StandardError => e
      raise Error, "Network error: #{e.message}"
    end

    def handle_http_error(error)
      status = error.io.status[0].to_i
      body = begin
        error.io.read
      rescue StandardError
        ""
      end

      case status
      when 404
        raise NotFoundError.new("Resource not found", status_code: 404, response_body: body)
      when 429
        raise RateLimitError.new("Rate limit exceeded. Please try again later.", status_code: 429, response_body: body)
      when 400..499
        raise APIError.new("Client error: #{status}", status_code: status, response_body: body)
      when 500..599
        raise APIError.new("Server error: #{status}", status_code: status, response_body: body)
      else
        raise APIError.new("HTTP Error: #{status}", status_code: status, response_body: body)
      end
    end

    def parse_json(body)
      JSON.parse(body, symbolize_names: true)
    rescue JSON::ParserError => e
      raise InvalidResponseError, "Failed to parse response: #{e.message}"
    end
  end
end
