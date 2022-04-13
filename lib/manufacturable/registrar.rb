require 'set'

module Manufacturable
  class Registrar
    ALL_KEY = :__all__
    DEFAULT_KEY = :__default__

    class << self
      def register(type, key, value)
        self.new(registry, type, key).register(value)
      end

      def get(type, key)
        self.new(registry, type, key).get
      end

      def registered_types
        registry.keys
      end

      def registered_keys(type)
        registry[type].keys
      end

      def reset!
        registry.clear
      end

      private

      def registry
        @registry ||= Hash.new { |h,k| h[k] = Hash.new }
      end
    end

    def initialize(registry, type, key)
      @registry, @type, @key = registry, type, key
    end

    def register(value)
      assign_set if set.nil?
      set.add(value)
    end

    def get
      merged_values.empty? ? default_values : merged_values
    end

    private

    def registry_key
      @registry_key ||= (@key.respond_to?(:to_sym) && @key.to_sym) || @key
    end

    def assign_set
      @registry[@type][registry_key] = Set.new
    end

    def set
      @registry[@type][registry_key]
    end

    def merged_values
      key_values.merge(all_values)
    end

    def key_values
      get_for(registry_key)
    end

    def all_values
      get_for(ALL_KEY)
    end

    def default_values
      get_for(DEFAULT_KEY)
    end

    def get_for(key)
      @registry[@type][key] || Set.new
    end
  end
end
