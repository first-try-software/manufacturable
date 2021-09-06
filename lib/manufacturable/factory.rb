require 'manufacturable/builder'

module Manufacturable
  module Factory
    def manufactures(klass)
      @type = klass
    end

    def build(key, *args)
      return if @type.nil?

      Builder.build(@type, key, *args)
    end

    def build_one(key, *args)
      return if @type.nil?

      Builder.build_one(@type, key, *args)
    end

    def build_many(key, *args)
      build_all(key, *args)
    end

    def build_all(key, *args)
      return [] if @type.nil?

      Builder.build_all(@type, key, *args)
    end

    def builds?(key)
      Builder.builds?(@type, key)
    end
  end
end
