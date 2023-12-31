# frozen_string_literal: true

require_relative "ddduel/aggregate_root"
require_relative "ddduel/repository"
require_relative "ddduel/use_case"
require_relative "ddduel/tx_wrapper"
require_relative "ddduel/event"
require_relative "ddduel/version"

module DDDuel
  class InvalidArgument < ArgumentError; end
  class Error < StandardError; end
end
