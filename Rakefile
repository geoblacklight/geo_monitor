begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'bundler/gem_tasks'
require 'engine_cart/rake_task'

EngineCart.fingerprint_proc = EngineCart.rails_fingerprint_proc

namespace :geomonitor do
  desc 'Create the test rails app'
  task generate: ['engine_cart:generate'] do
  end
end

task ci: ['geomonitor:generate'] do
  Rake::Task['spec'].invoke
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task default: :ci
rescue LoadError
  # no rspec available
end
