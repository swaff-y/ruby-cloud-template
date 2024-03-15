# frozen_string_literal: true

require 'mongo'
require 'logger'
require 'yaml'
require 'json'

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

  def self.account
    ENV.fetch('AWS_ACCOUNT')
  rescue # rubocop: disable Style/RescueStandardError
    JSON.parse(`aws sts get-caller-identity`)['Account']
  end

  def self.api_keys
    key = 'devKey'
    key = 'prodKey' if prod?

    [{ 'name' => key }]
  end

  def self.branch_name
    ENV.fetch('BRANCH', 'no-branch')
  end

  def self.region
    ENV.fetch('REGION', 'ap-southeast-2')
  end

  def self.application
    return 'cloud_template' if prod?

    'cloud_template_dev'
  end

  def self.version
    '0.1.1'
  end

  def self.application_description
    'A ruby template for aws cloud intergration using a mongo db'
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
  rescue # rubocop: disable Style/RescueStandardError
    'local'
  end

  def self.mongo_client
    Mongo::Client.new(mongo_url)
  end

  def self.mongo_url
    ENV.fetch('DB_CONNECTION_STRING')
  end

  def self.correct_coverage?(hash)
    hash.dig('result', 'line') > 80
  end

  def self.best_coverage?(hash)
    hash.dig('result', 'line') > 95
  end
end
