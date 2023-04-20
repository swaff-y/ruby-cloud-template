# frozen_string_literal: true

require 'mongo'
require 'logger'

# Application config
class Config
  def self.logger(type, message)
    log = Logger.new($stdout)
    error_log = Logger.new($stderr)

    case type
    when 'info'
      log.info(message)
    when 'debug'
      log.debug(message) unless prod?
    when 'error'
      error_log.error(message)
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
