# Fotmob Ruby Gem

[![Gem Version](https://badge.fury.io/rb/fotmob.svg)](https://badge.fury.io/rb/fotmob)
[![CI](https://github.com/bjrsti/fotmob/actions/workflows/ci.yml/badge.svg)](https://github.com/bjrsti/fotmob/actions/workflows/ci.yml)
[![Ruby](https://img.shields.io/badge/ruby-%3E%3D%202.7-ruby.svg)](https://www.ruby-lang.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An unofficial Ruby wrapper for the [FotMob](https://www.fotmob.com/) API. Get football/soccer data including team stats, match details, player information, and league standings.

## Features

- 🏆 **Team Data** - Get comprehensive team information and statistics
- ⚽ **Match Details** - Detailed match information and live scores
- 👤 **Player Stats** - Player profiles and performance data
- 📊 **League Standings** - League tables and competition data
- 🛡️ **Error Handling** - Custom error classes for different scenarios
- ⏱️ **Timeout Support** - Configurable request timeouts
- 📝 **Well Documented** - YARD documentation included

## Installation

Add to your Gemfile:

```ruby
gem 'fotmob'
```

Or install directly:

```bash
gem install fotmob
```

## Quick Start

```ruby
require 'fotmob'

# Create a client
client = Fotmob.new

# Get team information
team = client.get_team("8540") # Palermo
puts team[:details][:name]

# Get match details
match = client.get_match_details("4193741")
puts "#{match[:general][:homeTeam][:name]} vs #{match[:general][:awayTeam][:name]}"

# Get player data
player = client.get_player("961995") # Mbappé
puts player[:name]

# Get league standings
league = client.get_league("47") # Premier League
puts league[:details][:name]
```

## API Methods

### `get_team(team_id)`

Get comprehensive team information.

```ruby
team = client.get_team("8540")
# Returns: Hash with team details, fixtures, squad, etc.
```

### `get_match_details(match_id)`

Get detailed match information.

```ruby
match = client.get_match_details("4193741")
# Returns: Hash with match details, lineups, events, stats
```

### `get_player(player_id)`

Get player profile and statistics.

```ruby
player = client.get_player("961995")
# Returns: Hash with player info and stats
```

### `get_league(league_id)`

Get league/competition information.

```ruby
league = client.get_league("47")
# Returns: Hash with league details and standings
```

### `get_matches(date)` ⚠️

**Note:** This endpoint currently requires special authentication headers and may not work reliably.

```ruby
matches = client.get_matches("20250114")
# Returns: Hash with matches for the specified date
```

## Configuration

### Custom Timeout

```ruby
# Default timeout is 10 seconds
client = Fotmob.new(timeout: 30)
```

## Error Handling

The gem includes custom error classes for different scenarios:

```ruby
begin
  team = client.get_team("invalid_id")
rescue Fotmob::NotFoundError => e
  puts "Team not found: #{e.message}"
rescue Fotmob::RateLimitError => e
  puts "Rate limit exceeded: #{e.message}"
rescue Fotmob::TimeoutError => e
  puts "Request timed out: #{e.message}"
rescue Fotmob::APIError => e
  puts "API error: #{e.message} (Status: #{e.status_code})"
rescue Fotmob::Error => e
  puts "Error: #{e.message}"
end
```

### Error Classes

- `Fotmob::Error` - Base error class
- `Fotmob::APIError` - API returned an error response
- `Fotmob::NotFoundError` - Resource not found (404)
- `Fotmob::RateLimitError` - Rate limit exceeded (429)
- `Fotmob::TimeoutError` - Request timed out
- `Fotmob::InvalidResponseError` - Invalid JSON response

## Development

```bash
# Clone the repository
git clone https://github.com/bjrsti/fotmob.git
cd fotmob

# Install dependencies
bundle install

# Run tests
bundle exec rspec

# Run linter
bundle exec rubocop

# Open console
bundle exec rake console
```

## Testing

The gem uses RSpec for testing with VCR for recording API responses:

```bash
bundle exec rspec
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a Pull Request

## Finding IDs

To use the API, you need IDs for teams, players, matches, and leagues:

- **Teams**: Visit [fotmob.com](https://www.fotmob.com/), search for a team, the ID is in the URL
  - Example: `fotmob.com/teams/8540/overview/palermo` → Team ID: `8540`
- **Players**: Search for a player, ID is in the URL
  - Example: `fotmob.com/players/961995/kylian-mbappe` → Player ID: `961995`
- **Matches**: Browse matches, ID is in the match URL
  - Example: `fotmob.com/match/4193741` → Match ID: `4193741`
- **Leagues**: Browse leagues, ID is in the league URL
  - Example: `fotmob.com/leagues/47/overview/premier-league` → League ID: `47`

## Disclaimer

This is an unofficial API wrapper and is not affiliated with FotMob. Use at your own risk and be mindful of rate limits.

## License

MIT License. See [LICENSE](LICENSE) for details.

## Author

[Stian Bjørkelo](https://github.com/bjrsti)

## Links

- [RubyGems](https://rubygems.org/gems/fotmob)
- [GitHub](https://github.com/bjrsti/fotmob)
- [Issues](https://github.com/bjrsti/fotmob/issues)
