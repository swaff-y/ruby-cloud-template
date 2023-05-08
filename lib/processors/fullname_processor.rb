# frozen_string_literal: true

require_relative 'base'

module Processors
  # person model class
  class FullnameProcessor < Base
    attr_accessor :collection, :model

    def initialize(event, context, body, path_params, model)
      super(event, context)
      @body = body
      @model = model
      @path_params = path_params
    end

    def process(type)
      case type
      when 'post'
        @body['fullname'] = "#{@body['firstname']} #{@body['lastname']}"
      when 'put'
        @person = model.find_by_id(@path_params['id'])

        @body['fullname'] = "#{@body['firstname']} #{@body['lastname']}" if name_change?
      end
    end

    def name_change?
      return true unless @body['firstname'] == @person['firstname']

      return true unless @body['lastname'] == @person['lastname']
    end
  end
end
