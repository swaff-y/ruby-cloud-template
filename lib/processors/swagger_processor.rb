# frozen_string_literal: true

require_relative 'base'
require_relative '../tasks/swagger'

module Processors
  # swagger processor class
  class SwaggerProcessor
    def initialize
      @swagger = Tasks::Swagger.new
    end

    def process
      @swagger
    end
  end
end
