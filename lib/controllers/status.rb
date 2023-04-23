# frozen_string_literal: true

require 'json'
require_relative '../responses'
require_relative '../config'
require_relative '../processors/status_processor'

module Controllers
  # Status controller
  class Status
    def initialize(event, context)
      @event = event
      @context = context
      @processor = Processors::Status.new(event, context)
    end

    def get
      Config.logger('debug', "Received Request: #{@event} #{@context}")

      #Run processor
      db_name = @processor.process

      Responses._200({ status: 'Ok', database: db_name  })
    rescue Exceptions::ConnetionError => e
      Responses._500({ message: e.message, backtrace: nil })
    rescue StandardError => e
      Responses._500({ message: e.message, backtrace: e.backtrace })
    end
  end
end
