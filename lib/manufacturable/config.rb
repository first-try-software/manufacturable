module Manufacturable
  class Config
    class << self
      attr_writer :require_method

      def paths
        @paths ||= []
      end

      def load_paths
        paths.each { |path| require_path(path) }
      end

      private

      def require_method
        @require_method || :require
      end

      def require_path(path)
        Dir["#{path}/**/*.rb"].each { |file| require_file(file) }
      end

      def require_file(file)
        Kernel.public_send(require_method, file)
      end
    end
  end
end
