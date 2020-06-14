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
  end
end