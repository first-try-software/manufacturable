module Manufacturable
  class Dispatcher
    attr_reader :message, :receiver

    def initialize(message:, receiver:)
      @message = message
      @receiver = receiver
    end

    def method_missing(name, *args, **kwargs)
      return super unless respond_to?(name)

      Manufacturable.build_one(receiver, name, *args, **kwargs).public_send(message)
    end

    def respond_to_missing?(name, include_private = false)
      Manufacturable.builds?(receiver, name) || super
    end
  end
end
