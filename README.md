# Fotmob Rubygem

An unofficial [FotMob](https://www.fotmob.com/) API wrapper for Ruby

## Install

```ruby
gem install fotmob
```

## Usage

```ruby
require 'fotmob'

data = Fotmob.new

data.get_team("8540")
data.get_matches("20221030")
data.get_match_details("3901062")
data.get_league("47")
data.get_player("748382")

```