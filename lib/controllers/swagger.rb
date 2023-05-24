# frozen_string_literal: true

require 'json'
require_relative '../responses'
require_relative '../config'
require_relative '../processors/swagger_processor'
require_relative '../exceptions/exceptions'

module Controllers
  # Status controller
  class Swagger
    def initialize(event, context)
      @event = event
      @context = context
      @swagger_processor = Processors::SwaggerProcessor.new
    end

    def get
      @start = Time.now
      # Swagger processor
      swagger = @swagger_processor.process

      return JSON.generate(swagger.swagger) if Config.local?

      { statusCode: 200, body: JSON.generate(swagger.swagger) }
    rescue StandardError => e
      Responses._500({ message: e.message, backtrace: e.backtrace })
    ensure
      Config.logger('info', "Swagger Controller: Time completed -> #{ChronicDuration.output(Time.now - @start, format: :short)}")
    end
  end
end
