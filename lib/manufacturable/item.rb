require 'manufacturable/registrar'

module Manufacturable
  module Item
    def self.extended(base)
      base.instance_eval do
        def corresponds_to(key, type = self.superclass)
          key = key == type ? Registrar::ALL_KEY : key
          Registrar.register(type, key, self)
        end

        def corresponds_to_all(type = self.superclass)
          corresponds_to(Registrar::ALL_KEY, type)
        end

        def default_manufacturable(type = self.superclass)
          corresponds_to(Registrar::DEFAULT_KEY, type)
        end

        def new(*args, **kwargs, &block)
          key = kwargs.delete(:manufacturable_item_key)
          instance = kwargs.empty? ? super(*args, &block) : super
          instance.instance_variable_set(:@manufacturable_item_key, key)
          instance
        end
      end

      base.class_eval do
        attr_reader :manufacturable_item_key
      end
    end
  end
end
