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

  def self.application
    'cloud_template'
  end

  def self.application_serverless
    'cloud-template'
  end

  def self.local?
    true if stage == 'local'
  end

  def self.dev?
    true if stage == 'dev'
  end

  def self.prod?
    true if stage == 'prod'
  end

  def self.stage
    stage = ENV.fetch('STAGE')
    return 'dev' unless stage.nil?

    'local'
  end

  def self.mongo_client
    Mongo::Client.new(mongo_url)
  end

  def self.mongo_url
    ENV.fetch('DB_CONNECTION_STRING')
  end

  def self.correct_coverage?(hash)
    hash.dig('result', 'line') < 80
  end

  def self.best_coverage?(hash)
    hash.dig('result', 'line') > 95
  end
end
