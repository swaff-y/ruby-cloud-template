# frozen_string_literal: true

require_relative 'base'

module Processors
  # person model class
  class FullnameProcessor < Base
    attr_accessor :collection, :model

    def initialize(event, context, body)
      super(event, context)
      @body = body
    end

    def process
      @body['fullname'] = @body['firstname'] + @body['lastname']
    end
  end
end
