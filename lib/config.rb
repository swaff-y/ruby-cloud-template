# frozen_string_literal: true

require 'mongo'

# Application config
class Config
  class << self
    def self.logger(type, message)
      case type
      when 'info'
        puts message
      when 'debug'
        puts 'message' unless stage.prod?
      when 'error'
        puts "Error: #{message}"
      end
    end
  
    def prod?
      true if stage == 'prod'
    end
  
    def self.stage
      'prod' unless ENV.fetch('STAGE').nil?
  
      'dev'
    end

    def mongo_client
      Mongo::Client.new(mongo_url)
    end

    def mongo_url
      ENV.fetch('DB_CONNECTION_STRING')
    end
  end
end
