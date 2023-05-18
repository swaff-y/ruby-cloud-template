# frozen_string_literal: true

require_relative '../exceptions/exceptions'

module Validation
  # Status Valication class
  class Status
    def initialize(event, context)
      @event = event
      @context = context
    end

    def process
      client_name = Config&.mongo_client&.database&.name

      raise Exceptions::ConnectionError, "Could not connect to the database (#{client_name})" unless client_name == Config.application

      client_name
    end
  end
end
