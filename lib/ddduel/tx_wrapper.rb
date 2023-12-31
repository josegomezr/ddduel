# frozen_string_literal: true

module DDDuel
  class TxWrapper
    def initialize(tx_manager: , use_case: )
      raise InvalidArgument.new("#{use_case.class} is not a '#{UseCase}'") unless use_case.is_a?(UseCase)

      @tx_manager = tx_manager
      @use_case = use_case
    end

    def call(...)
      @tx_manager.call do
        @use_case.call(...)
      end
    end
  end
end
