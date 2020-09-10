require 'manufacturable/registrar'

module Manufacturable
  class Builder
    def self.build(*args, **kwargs)
      self.new(*args, **kwargs).build
    end

    def self.build_one(*args, **kwargs)
      self.new(*args, **kwargs).build_one
    end

    def self.build_all(*args, **kwargs)
      self.new(*args, **kwargs).build_all
    end

    def build
      return_first? ? instances.first : instances
    end

    def build_one
      last_instance
    end

    def build_all
      instances
    end

    private

    attr_reader :type, :key, :args, :kwargs

    def initialize(type, key, *args, **kwargs)
      @type, @key, @args, @kwargs = type, key, args, kwargs
    end

    def return_first?
      instances.size < 2
    end

    def instances
      @instances ||= klasses.map { |klass| klass&.new(*args, **kwargs_with_key) }
    end

    def klasses
      Registrar.get(type, key)
    end

    def last_instance
      last_klass&.new(*args, **kwargs_with_key)
    end

    def kwargs_with_key
      kwargs.merge(manufacturable_item_key: key)
    end

    def last_klass
      klasses.to_a.last
    end
  end
end
