# frozen_string_literal: true

module GeoMonitor
  # Base class for all models in the engine
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
