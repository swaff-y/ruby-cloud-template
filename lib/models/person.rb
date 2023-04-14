# frozen_string_literal: true

require_relative './base'

module Models
  # person model class
  class Person < Base
    def initialize(event, context)
      super(event, context)
      client = Config.mongo_client
      @collection = client[:persons]
      @model = self
    end

    def map(hash)
      {
        'id' => hash['id']
      }
    end
  end
end
