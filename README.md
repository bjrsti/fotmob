# Fotmob Ruby Gem

[![Gem Version](https://badge.fury.io/rb/fotmob.svg)](https://badge.fury.io/rb/fotmob)
[![CI](https://github.com/bjrsti/fotmob/actions/workflows/ci.yml/badge.svg)](https://github.com/bjrsti/fotmob/actions/workflows/ci.yml)
[![Ruby](https://img.shields.io/badge/ruby-%3E%3D%202.7-ruby.svg)](https://www.ruby-lang.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An unofficial Ruby wrapper for the [FotMob](https://www.fotmob.com/) API. Get football/soccer data including team stats, match details, and league standings.

## Features

- 🏆 **Team Data** - Get comprehensive team information and statistics
- ⚽ **Match Details** - Detailed match information including lineups, stats, and live scores
- 📅 **Matches by Date** - All matches for a given day across 150+ leagues
- 📊 **League Data** - League tables, fixtures, and competition details
- 🛡️ **Error Handling** - Custom error classes for different scenarios
- ⏱️ **Configurable** - Timeout and timezone support

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

client = Fotmob.new

# All matches for today
matches = client.get_matches("20251030")
matches[:leagues].each { |l| puts l[:name] }

# Match details (lineups, stats, events)
match = client.get_match_details("5315746")
puts "#{match[:general][:homeTeam][:name]} vs #{match[:general][:awayTeam][:name]}"
puts match[:header][:status][:scoreStr]

# Team info
team = client.get_team("8455") # Chelsea
puts team[:details][:name]

# League standings
league = client.get_league("47") # Premier League
puts league[:details][:name]
```

## API Methods

### `get_matches(date)`

All matches for a given date (150+ leagues).

```ruby
matches = client.get_matches("20251030")
# Returns: { leagues: [...], date: "..." }
# Each league has a :matches array with scores, teams, status
```

### `get_match_details(match_id)`

Full match data — lineups, stats, events, shotmap.

```ruby
match = client.get_match_details("5315746")
# Returns: { general:, header:, content: { stats:, lineup:, shotmap:, ... } }
```

### `get_team(team_id)`

Team overview, fixtures, and squad.

```ruby
team = client.get_team("8455")
# Returns: { details:, overview:, fixtures:, ... }
```

### `get_league(league_id)`

League table, fixtures, and stats.

```ruby
league = client.get_league("47")
# Returns: { details:, table:, fixtures:, stats:, ... }
```

## Configuration

```ruby
# Defaults: timeout 10s, timezone Europe/Paris
client = Fotmob.new(timeout: 30, timezone: "America/New_York")
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

IDs are in the fotmob.com URL for each resource:

- **Teams**: `fotmob.com/teams/8455/overview/chelsea` → `8455`
- **Matches**: `fotmob.com/matches/chelsea-vs-manchester-city/abc123#5315746` → `5315746`
- **Leagues**: `fotmob.com/leagues/47/overview/premier-league` → `47`

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
