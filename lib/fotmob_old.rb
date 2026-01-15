# frozen_string_literal: true

require "open-uri"
require "json"

class Fotmob
  BASE_URL          = "http://www.fotmob.com/api"
  LEAGUES_URL       = "#{BASE_URL}/leagues?id="
  MATCHES_URL       = "#{BASE_URL}/matches?date="
  MATCH_DETAILS_URL = "#{BASE_URL}/matchDetails?matchId="
  PLAYER_URL        = "#{BASE_URL}/playerData?id="
  TEAMS_URL         = "#{BASE_URL}/teams?id="

  def get_league(league_id)
    json = URI.open(LEAGUES_URL + league_id).read
    symbolize_json(json)
  end

  def get_matches(match_date)
    json = URI.open(MATCHES_URL + match_date).read
    symbolize_json(json)
  end

  def get_match_details(match_id)
    json = URI.open(MATCH_DETAILS_URL + match_id).read
    symbolize_json(json)
  end

  def get_player(player_id)
    json = URI.open(PLAYER_URL + player_id).read
    symbolize_json(json)
  end

  def get_team(team_id)
    json = URI.open(TEAMS_URL + team_id).read
    symbolize_json(json)
  end

  private

  def symbolize_json(json)
    JSON.parse(json, symbolize_names: true)
  end
end
