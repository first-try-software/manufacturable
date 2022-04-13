module Manufacturable
  class SimpleRegistrar
    class << self
      def register(key, value)
        self.new(registry, key).register(value)
      end

      def entries(*keys)
        registry.slice(*keys)
      end

      private

      def registry
        @registry ||= Hash.new
      end
    end

    def initialize(registry, key)
      @registry, @key = registry, key
    end

    def register(value)
      @registry[registry_key] = value
    end

    private

    def registry_key
      @registry_key ||= (@key.respond_to?(:to_sym) && @key.to_sym) || @key
    end
  end
end
