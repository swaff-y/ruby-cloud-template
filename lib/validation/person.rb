# frozen_string_literal: true

require_relative '../exceptions/exceptions'

module Validation
  # Status controller
  class Person
    def initialize(event, context)
      @event = event
      @context = context
      @path_parameters = event['pathParameters']
      @query_string_parameters = event['queryStringParameters']
      event['body'] = '' if event['body'].nil?
      @body = JSON.parse(event['body']) unless event['body'].strip.empty?
    end

    def validate_get_by_id
      raise Exceptions::InvalidParametersError, 'Parameters missing: ID' if @path_parameters['id'].nil?
    end

    def validate_get
      raise Exceptions::InvalidParametersError, 'Parameters missing: No request parameters' if @query_string_parameters.nil? || @query_string_parameters.empty?
    end

    def validate_post
      raise Exceptions::InvalidParametersError, 'Parameters missing: No body' if @body.nil?
    end

    def validate_put
      raise Exceptions::InvalidParametersError, 'Parameters missing: ID' if @path_parameters['id'].nil?
      raise Exceptions::InvalidParametersError, 'Parameters missing: No body' if @body.nil?
    end

    def validate_delete
      raise Exceptions::InvalidParametersError, 'Parameters missing: ID' if @path_parameters['id'].nil?
    end
  end
end
