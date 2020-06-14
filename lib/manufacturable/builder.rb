require 'manufacturable/registrar'

module Manufacturable
  class Builder
    def self.build(*args)
      self.new(*args).build
    end

    def build
      return_first? ? instances.first : instances
    end

    private

    attr_reader :type, :key, :args

    def initialize(type, key, *args)
      @type, @key, @args = type, key, args
    end

    def klasses
      Registrar.get(type, key)
    end

    def instances
      @instances ||= klasses.map { |klass| klass&.new(*args) }
    end

    def return_first?
      instances.size < 2
    end
  end
end
