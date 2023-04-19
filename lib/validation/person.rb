# frozen_string_literal: true

module Validation
  # Status controller
  class Person
    def initialize(event, context)
      @event = event
      @context = context
      @pathParameters = event['pathParameters']
      @queryStringParameters = event['queryStringParameters']
      event['body'] = '' if event['body'].nil?
      @body = JSON.parse(event['body']) unless event['body'].strip.empty?
    end

    def validate_get_by_id
      raise Exceptions::InvalidParametersError, 'Parameters missing: ID' if @pathParameters['id'].nil?
    end

    def validate_get
      raise Exceptions::InvalidParametersError, 'Parameters missing: No request parameters' if @queryStringParameters.nil? || @queryStringParameters.empty?
    end

    def validate_post
      raise Exceptions::InvalidParametersError, 'Parameters missing: No body' if @body.nil?
    end
  end
end