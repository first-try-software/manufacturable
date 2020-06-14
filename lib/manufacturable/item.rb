require 'manufacturable/registrar'

module Manufacturable
  module Item
    def corresponds_to(key)
      key = key == self.superclass ? Registrar::ALL_KEY : key
      Registrar.register(self.superclass, key, self)
    end

    def corresponds_to_all
      corresponds_to(Registrar::ALL_KEY)
    end

    def default_manufacturable
      corresponds_to(Registrar::DEFAULT_KEY)
    end
  end
end
