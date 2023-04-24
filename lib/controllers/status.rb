# frozen_string_literal: true

require 'json'
require_relative '../responses'
require_relative '../config'
require_relative '../validation/status'
require_relative '../exceptions/exceptions'

module Controllers
  # Status controller
  class Status
    def initialize(event, context)
      @event = event
      @context = context
      @validation = Validation::Status.new(event, context)
    end

    def get
      Config.logger('debug', "Received Request: #{@event} #{@context}")

      # Validate db connection
      db_name = @validation.process

      Responses._200({ status: 'Ok', database: db_name })
    rescue Exceptions::ConnectionError => e
      Responses._500({ message: e.message, backtrace: nil })
    rescue StandardError => e
      Responses._500({ message: e.message, backtrace: e.backtrace })
    end
  end
end
