# frozen_string_literal: true

require_relative './base'

module Models
  # person model class
  class Person < Base
    attr_accessor :collection

    def initialize(event, context)
      super(event, context)
      client = Config.mongo_client
      @collection = client[:persons]
      @model = self
    end

    def map(hash)
      {
        'id' => hash['id'],
        'firstname' => hash['firstname'],
        'lastname' => hash['lastname'],
        'weight' => hash['weight'],
        'height' => hash['height']
      }
    end
  end
end
