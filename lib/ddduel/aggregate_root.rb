# frozen_string_literal: true

module DDDuel
  module AggregateRoot
    def ddd_delete_domain_events!
      @domain_events
    ensure
      @domain_events = []
    end

    def ddd_record_event(event)
      (@domain_events ||= []) << event
    end
  end
end
