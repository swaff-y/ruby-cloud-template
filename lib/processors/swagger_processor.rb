# frozen_string_literal: true

require_relative 'base'
require_relative '../tasks/swagger'

module Processors
  # person model class
  class SwaggerProcessor < Base

    def initialize
      @swagger = Tasks::Swagger.new
    end

    def process
      @swagger
    end
  end
end
