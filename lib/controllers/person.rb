# frozen_string_literal: true

require 'chronic_duration'
require 'json'
require_relative '../responses'
require_relative '../config'
require_relative '../validation/person'
require_relative '../models/person'

module Controllers
  # Status controller
  class Person
    def initialize(event, context)
      @event = event
      @context = context
      @validation = Validation::Person.new(event, context)
      @model = Models::Person.new(event, context)
      @path_parameters = event['pathParameters']
      @query_string_parameters = event['queryStringParameters']
      event['body'] = '' if event['body'].nil?
      @body = JSON.parse(event['body']) unless event['body'].strip.empty?
      @start = Time.now
    end

    def get_by_id # rubocop: disable Naming/AccessorMethodName
      rec_log

      # validate
      @validation.validate_get_by_id

      # run model
      res = @model.find_by_id(@path_parameters['id'])

      Responses._200(res)
    rescue Exceptions::InvalidParametersError => e
      Responses._400({ message: e.message })
    rescue BSON::ObjectId::Invalid
      Responses._400({ message: 'Invalid person ID' })
    rescue StandardError => e
      Responses._500({ message: e.message, backtrace: e.backtrace })
    ensure
      Config.logger('info', "Person Controller: Time completed -> #{ChronicDuration.output(Time.now - @start, format: :short)}")
    end

    def get
      rec_log

      # validate
      @validation.validate_get

      # run model
      res = @model.find(@query_string_parameters)

      Responses._200(res)
    rescue Exceptions::InvalidParametersError => e
      Responses._400({ message: e.message })
    rescue StandardError => e
      Responses._500({ message: e.message, backtrace: e.backtrace })
    ensure
      Config.logger('info', "Person Controller: Time completed -> #{ChronicDuration.output(Time.now - @start, format: :short)}")
    end

    def post
      rec_log

      # validate
      @validation.validate_post

      # run model
      res = @model.post(@body)

      Responses._200({ Id: res.to_s })
    rescue Exceptions::SchemaError => e
      Responses._400({ message: JSON.parse(e.message, { symbolize_names: true }) })
    rescue Exceptions::InvalidParametersError => e
      Responses._400({ message: e.message })
    rescue Exceptions::RecordNotCreatedError => e
      Responses._500({ message: e.message, backtrace: '' })
    rescue StandardError => e
      Responses._500({ message: e.message, backtrace: e.backtrace })
    ensure
      Config.logger('info', "Person Controller: Time completed -> #{ChronicDuration.output(Time.now - @start, format: :short)}")
    end

    def put
      rec_log

      # validate

      # run processors

      # run model
      model.create({ test: 'value' })

      Responses._200({ status: 'Ok' })
    rescue StandardError => e
      Responses._500({ message: e.message, backtrace: e.backtrace })
    ensure
      Config.logger('info', "Person Controller: Time completed -> #{ChronicDuration.output(Time.now - @start, format: :short)}")
    end

    def delete
      rec_log

      # validate

      # run model
      @model.delete({ test: 'value' })

      Responses._200({ status: 'Ok' })
    rescue StandardError => e
      Responses._500({ message: e.message, backtrace: e.backtrace })
    ensure
      Config.logger('info', "Person Controller: Time completed -> #{ChronicDuration.output(Time.now - @start, format: :short)}")
    end

    def rec_log
      Config.logger('debug', "Received Request: #{@event} #{@context}")
    end
  end
end
