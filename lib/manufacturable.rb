require 'manufacturable/version'
require 'manufacturable/config'
require 'manufacturable/factory'
require 'manufacturable/item'
require 'manufacturable/object_factory'
require 'manufacturable/railtie' if defined?(Rails)

module Manufacturable
  def self.build(*args)
    Builder.build(*args)
  end

  def self.build_one(*args)
    Builder.build_one(*args)
  end

  def self.build_many(*args)
    Builder.build_all(*args)
  end

  def self.build_all(*args)
    Builder.build_all(*args)
  end

  def self.registered_types
    Registrar.registered_types
  end

  def self.registered_keys(type)
    Registrar.registered_keys(type)
  end

  def self.reset!
    Registrar.reset!
  end

  def self.config
    yield(Config)
    Config.load_paths
  end
end
