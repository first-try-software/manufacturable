require 'manufacturable/registrar'

module Manufacturable
  class Builder
    def self.build(*args)
      self.new(*args).build
    end

    def self.build_one(*args)
      self.new(*args).build_one
    end

    def self.build_all(*args)
      self.new(*args).build_all
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

    attr_reader :type, :key, :args

    def initialize(type, key, *args)
      @type, @key, @args = type, key, args
    end

    def return_first?
      instances.size < 2
    end

    def instances
      @instances ||= klasses.map { |klass| klass&.new(*args) }
    end

    def klasses
      Registrar.get(type, key)
    end

    def last_instance
      last_klass&.new(*args)
    end

    def last_klass
      klasses.to_a.last
    end
  end
end
