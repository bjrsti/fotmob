# frozen_string_literal: true

require_relative "lib/fotmob/version"

Gem::Specification.new do |s|
  s.name            = "fotmob"
  s.version         = Fotmob::VERSION
  s.summary         = "An unofficial FotMob API wrapper for Ruby"
  s.description     = "A simple Ruby gem for accessing football/soccer data from the FotMob API. " \
                      "Get team stats, match details, player data, league tables, and more."
  s.authors         = ["Stian Bjørkelo"]
  s.email           = "stianbj@gmail.com"
  s.homepage        = "https://github.com/bjrsti/fotmob"
  s.license         = "MIT"

  s.required_ruby_version = ">= 2.7.0"

  s.files           = Dir["lib/**/*.rb", "README.md", "LICENSE", "CHANGELOG.md"]
  s.require_paths   = ["lib"]

  s.metadata = {
    "homepage_uri" => "https://github.com/bjrsti/fotmob",
    "source_code_uri" => "https://github.com/bjrsti/fotmob",
    "bug_tracker_uri" => "https://github.com/bjrsti/fotmob/issues",
    "changelog_uri" => "https://github.com/bjrsti/fotmob/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://github.com/bjrsti/fotmob#readme",
    "rubygems_mfa_required" => "true"
  }

  # Runtime dependencies (stdlib, no version needed)
  # open-uri and json are part of Ruby stdlib, no need to declare

  # Development dependencies
  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "rspec", "~> 3.12"
  s.add_development_dependency "rubocop", "~> 1.50"
  s.add_development_dependency "vcr", "~> 6.1"
  s.add_development_dependency "webmock", "~> 3.18"
end
