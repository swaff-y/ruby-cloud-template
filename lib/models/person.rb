# frozen_string_literal: true

require_relative './base'

module Models
  # person model class
  class Person < Base
    attr_accessor :collection, :model

    def initialize(event, context)
      super(event, context)
      client = Config.mongo_client
      @collection = client[:persons]
      @model = self
    end

    def schema
      {
        firstname: {
          type: String,
          required: true,
          description: 'A description'
        },
        lastname: {
          type: String,
          required: true,
          description: 'A description'
        },
        fullname: {
          type: String,
          required: true,
          unique: true,
          description: 'A description'
        },
        weight: {
          type: Integer,
          required: true,
          description: 'A description'
        },
        height: {
          type: Integer,
          required: true,
          description: 'A description'
        }
      }
    end
  end
end
