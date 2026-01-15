# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2026-01-15

### Added
- Initial release of modernized fotmob gem
- Modern project structure with separate modules
- Custom error classes (Error, APIError, NotFoundError, RateLimitError, TimeoutError, InvalidResponseError)
- URI.open-based HTTP client with timeout support
- Comprehensive error handling with proper HTTP status codes
- YARD documentation for all public methods
- RSpec test suite with VCR for API response recording
- RuboCop linting with sensible defaults
- GitHub Actions CI for automated testing
- Gemfile and Rakefile for development workflow
- Comprehensive README with examples and badges

### Changed
- Refactored from single-file to modular structure
- Improved from basic API wrapper to production-ready gem
- Switched to symbolized JSON keys for better Ruby idioms
- Added timeout configuration support

### API Methods
- `get_team(team_id)` - Get team information and statistics
- `get_match_details(match_id)` - Get detailed match information
- `get_player(player_id)` - Get player profile and stats
- `get_league(league_id)` - Get league standings and details
- `get_matches(date)` - Get matches by date (limited availability)

### Technical Details
- Requires Ruby >= 2.7.0
- Uses standard library only (no runtime dependencies)
- Tested on Ruby 2.7, 3.0, 3.1, 3.2, 3.3
- Bot protection handling via URI.open
- Configurable timeout (default: 10 seconds)

### Known Limitations
- `get_matches` endpoint requires special authentication headers and may not work reliably
- API is unofficial and may change without notice

[0.0.1]: https://github.com/bjrsti/fotmob/releases/tag/v0.0.1
