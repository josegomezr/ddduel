# frozen_string_literal: true
require "ddduel/use_case/request"
require "ddduel/use_case/response"

module DDDuel
  class UseCase
    def call(request = nil)
      raise InvalidArgument.new("nope, '#{request.class}' is not a request") if request and !request.is_a?(Request)
      execute!(request)
    end

    def execute!(request = nil)
      raise NoMethodError.new('#execute not defined')
    end
  end
end
