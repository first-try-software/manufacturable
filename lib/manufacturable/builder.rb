require 'manufacturable/registrar'

module Manufacturable
  class Builder
    def self.build(*args, **kwargs, &block)
      self.new(*args, **kwargs, &block).build
    end

    def self.build_one(*args, **kwargs, &block)
      self.new(*args, **kwargs, &block).build_one
    end

    def self.build_all(*args, **kwargs, &block)
      self.new(*args, **kwargs, &block).build_all
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

    attr_reader :type, :key, :args, :kwargs, :block

    def initialize(*args, **kwargs, &block)
      @type, @key, *@args = args
      @kwargs, @block = kwargs, block
    end

    def return_first?
      instances.size < 2
    end

    def instances
      @instances ||= klasses.map do |klass|
        klass.new(*args, **kwargs_with_key).tap { |instance| block&.call(instance) }
      end
    end

    def last_instance
      last_klass&.new(*args, **kwargs_with_key)&.tap { |instance| block&.call(instance) }
    end

    def klasses
      Registrar.get(type, key).to_a
    end

    def kwargs_with_key
      kwargs.merge(manufacturable_item_key: key)
    end

    def last_klass
      klasses.last
    end
  end
end
