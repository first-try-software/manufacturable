require 'manufacturable/config'

module Manufacturable
  class Railtie < Rails::Railtie
    initializer "manufacturable.require_paths" do |app|
      Manufacturable::Config.require_method = app.config.eager_load ? :require : :require_dependency
    end
  end
end
