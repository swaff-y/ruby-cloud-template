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
      # Swagger processor
      swagger = @swagger_processor.process

      JSON.generate(swagger.swagger)
    rescue StandardError => e
      Responses._500({ message: e.message, backtrace: e.backtrace })
    end
  end
end
