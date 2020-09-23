require 'manufacturable/version'
require 'manufacturable/config'
require 'manufacturable/factory'
require 'manufacturable/item'
require 'manufacturable/object_factory'
require 'manufacturable/railtie'

module Manufacturable
  def self.build(*args, **kwargs, &block)
    Builder.build(*args, **kwargs, &block)
  end

  def self.build_one(*args, **kwargs, &block)
    Builder.build_one(*args, **kwargs, &block)
  end

  def self.build_many(*args, **kwargs, &block)
    Builder.build_all(*args, **kwargs, &block)
  end

  def self.build_all(*args, **kwargs, &block)
    Builder.build_all(*args, **kwargs, &block)
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
