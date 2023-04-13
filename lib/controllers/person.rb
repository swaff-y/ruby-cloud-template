# frozen_string_literal: true

require 'json'
require_relative '../responses'
require_relative '../config'
require_relative '../models/person'

module Controllers
  # Status controller
  class Person
    def initialize(event, context)
      @event = event
      @context = context
    end

    def get
      Config.logger('debug', "Received Request: #{@event} #{@context}")
      model = Models::Person.new(@event, @context)

      # validate

      # run processors

      # run model
      res = model.find(@event['pathParameters'])

      Responses._200({ status: res })
    rescue Exceptions::InvalidParametersError => e
      Responses._400({ message: e.message })
    rescue StandardError => e
      Responses._500({ message: e.message, backtrace: e.backtrace })
    end

    def post
      Config.logger('debug', "Received Request: #{@event} #{@context}")
      model = Models::Person.new(@event, @context)

      # validate

      # run processors

      # run model
      model.create({ test: 'value' })

      Responses._200({ status: 'Ok' })
    rescue StandardError => e
      Responses._500({ message: e.message, backtrace: e.backtrace })
    end

    def put
      Config.logger('debug', "Received Request: #{@event} #{@context}")
      model = Models::Person.new(@event, @context)

      # validate

      # run processors

      # run model
      model.create({ test: 'value' })

      Responses._200({ status: 'Ok' })
    rescue StandardError => e
      Responses._500({ message: e.message, backtrace: e.backtrace })
    end

    def delete
      Config.logger('debug', "Received Request: #{@event} #{@context}")
      model = Models::Person.new(@event, @context)

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
