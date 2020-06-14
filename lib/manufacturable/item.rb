require 'manufacturable/registrar'

module Manufacturable
  module Item
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
  end
end
