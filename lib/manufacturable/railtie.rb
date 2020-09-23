require 'manufacturable/config'

module Manufacturable
  class Railtie
    def self.load
      load_railtie if rails_defined?
    end

    def self.load_railtie
      Class.new(Rails::Railtie).initializer('manufacturable.require_paths') do |app|
        Manufacturable::Config.require_method = app.config.eager_load ? :require : :require_dependency
      end
    end

    def self.rails_defined?
      defined?(Rails)
    end
  end
end

Manufacturable::Railtie.load