# frozen_string_literal: true

module DDDuel
  class Repository
    def initialize(relation: )
      @relation = relation
    end

    def save(aggregate)
      print "saving #{aggregate.class}"
      # aggregate.model.save!
    end
  end
end

