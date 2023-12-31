# frozen_string_literal: true
require 'securerandom'

module DDDuel
  class Event
    def self.id_factory
      ::SecureRandom.uuid
    end

    attr_reader :aggregate_id, :data, :id, :happened_at

    def initialize(aggregate_id: , data: {}, id: nil, happened_at: nil)
      @aggregate_id = aggregate_id
      @data = data
      @id = id || self.class.id_factory()
      @happened_at = happened_at || Time.now.utc
    end
  end
end
