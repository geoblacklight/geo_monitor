require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root './spec/test_app_templates'

  # if you need to generate any additional configuration
  # into the test app, this generator will be run immediately
  # after setting up the application

  def install_engine
    generate 'geo_monitor:install'
  end

  def run_spotlight_migrations
    rake 'geo_monitor:install:migrations'
    rake 'db:migrate'
  end
end
