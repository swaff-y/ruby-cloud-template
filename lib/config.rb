# frozen_string_literal: true

require 'mongo'
require 'logger'
require 'yaml'
require 'aws-sdk-secretsmanager'

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
    ENV.fetch('STAGE')
  rescue KeyError
    'local'
  end

  def self.mongo_client
    Mongo::Client.new(mongo_url)
  end

  def self.mongo_url
    ENV.fetch('DB_CONNECTION_STRING')
  rescue KeyError
    db_connection_string
  end

  def self.correct_coverage?(hash)
    hash.dig('result', 'line') < 82
  end

  def self.best_coverage?(hash)
    hash.dig('result', 'line') > 95
  end

  def self.db_connection_string
    client = Aws::SecretsManager::Client.new(region: 'ap-southeast-2')

    get_secret_value_response = client.get_secret_value(secret_id: 'Cloud-template-db-connection-string')
    JSON.parse(get_secret_value_response.secret_string)['DB_CONNECTION_STRING']
  end
end
