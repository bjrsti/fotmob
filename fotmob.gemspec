Gem::Specification.new do |s|
  s.name            = "fotmob"
  s.version         = "0.0.1"
  s.summary         = "An unofficial Fotmob API wrapper for Ruby"
  s.description     = "Lets you pull data from fotmob for easy access"
  s.authors         = ["Stian Bjørkelo"]
  s.email           = "stianbj@gmail.com"
  s.files           = Dir["lib/**/*.rb"]
  s.homepage        = "https://github.com/bjrsti/fotmob"
  s.license         = "MIT"
  
  s.add_runtime_dependency 'open-uri', '~> 0.2', '>= 0.2.0'
  s.add_runtime_dependency 'json', '~> 2.6', '>= 2.6.2'
end