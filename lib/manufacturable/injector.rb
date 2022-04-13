require 'manufacturable/simple_registrar'

module Manufacturable
  class Injector
    class << self
      def inject(klass, *args, **kwargs)
        params = dependencies_for(klass).merge(**kwargs)
        klass.new(*args, **params)
      end

      private

      def dependencies_for(klass)
        return {} unless klass.private_method_defined?(:initialize)

        params = klass
          .instance_method(:initialize)
          .parameters
          .select { |(type, name)| type == :keyreq }
          .map(&:last)

        SimpleRegistrar.entries(*params)
      end
    end
  end
end
