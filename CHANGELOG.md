# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-05-16

### Changed
- Updated all API endpoints to match FotMob's current backend (`/api/data/`)
- `get_matches` fully working — returns all matches across 150+ leagues for a date
- `get_match_details` reimplemented via Next.js SSR data (full lineups, stats, events)
- `get_match_details` now auto-refreshes build ID on stale deploys (transparent retry)
- Added `timezone` option to client (default: `Europe/Paris`)
- Removed `get_player` — endpoint now requires Cloudflare Turnstile (browser-only)

## [0.1.0] - 2026-01-15

### Added
- Initial release
- `get_team`, `get_match_details`, `get_player`, `get_league`, `get_matches`
- Custom error classes, configurable timeout, VCR-based test suite

[0.1.0]: https://github.com/bjrsti/fotmob/releases/tag/v0.1.0
