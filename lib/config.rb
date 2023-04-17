# frozen_string_literal: true

require 'mongo'

# Application config
class Config
  def self.logger(type, message)
    case type
    when 'info'
      puts message
    when 'debug'
      puts 'message' unless prod?
    when 'error'
      puts "Error: #{message}"
    end
  end

  def self.local?
    true if stage == 'local'
  end

  def self.prod?
    true if stage == 'prod'
  end

  def self.stage
    ENV.fetch('STAGE') unless ENV.fetch('STAGE').nil?

    'local'
  end

  def self.mongo_client
    Mongo::Client.new(mongo_url)
  end

  def self.mongo_url
    ENV.fetch('DB_CONNECTION_STRING')
  end
end
