# frozen_string_literal: true

require 'json'
require_relative '../responses'
require_relative '../config'
require_relative '../models/status'

module Controllers
  # Status controller
  class Status
    def initialize(event, context)
      @event = event
      @context = context
    end

    def get
      Config.logger('debug', "Received Request: #{@event} #{@context}")
      model = Models::Status.new(@event, @context)

      # validate

      # run processors

      # run model
      model.create({ test: 'value' })

      Responses._200({ status: 'Ok' })
    rescue StandardError => e
      Responses._500({ message: e.message, backtrace: e.backtrace })
    end
  end
end
