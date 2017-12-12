$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'geo_monitor/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'geo_monitor'
  s.version     = GeoMonitor::VERSION
  s.authors     = ['Jack Reed']
  s.email       = ['phillipjreed@gmail.com']
  s.homepage    = 'https://github.com/geoblacklight/geo_monitor'
  s.summary     = 'A Rails engine for monitoring geo webservices'
  s.description = 'A Rails engine for monitoring geo webservices'
  s.license     = 'Apache 2.0'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1.4'
  s.add_dependency 'faraday'
  s.add_dependency 'engine_cart'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'webmock'
end
