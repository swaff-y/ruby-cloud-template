# frozen_string_literal: true

require 'json'
require_relative '../responses'
require_relative '../config'

module Controllers
  # Status controller
  class Status
    def initialize(event, context)
      @event = event
      @context = context
    end

    def get
      Config.logger('debug', "Received Request: #{@event} #{@context}")

      Responses._200({ status: 'Ok' })
    rescue StandardError => e
      Responses._500({ message: e.message, backtrace: e.backtrace })
    end
  end
end
