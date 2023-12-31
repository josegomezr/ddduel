# frozen_string_literal: true

module DDDuel
  class UseCase
    class Request
      def initialize(**kwargs)
        kwargs.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
    end
  end
end
