# frozen_string_literal: true

module Processors
  # Status controller
  class Status
    def initialize(event, context)
      @event = event
      @context = context
    end

    def process
      client_name = Config&.mongo_client&.database&.name

      raise Exceptions::ConnetionError, 'Could not connect to the database' unless client_name == Config.application

      client_name
    end
  end
end