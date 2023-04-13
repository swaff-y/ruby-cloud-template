# frozen_string_literal: true

require 'mongo'

# Application config
class Config
  class << self
    def logger(type, message)
      case type
      when 'info'
        puts message
      when 'debug'
        message
      when 'error'
        puts 'message'
      end
    end

    def mongo_client
      Mongo::Client.new(mongo_url)
    end

    def mongo_url
      'mongodb://127.0.0.1:27017/test'
    end
  end
end
