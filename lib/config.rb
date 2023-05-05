# frozen_string_literal: true

require 'mongo'
require 'logger'
require 'yaml'
require 'aws-sdk-secretsmanager'
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
  rescue
    JSON.parse(`aws sts get-caller-identity`)['Account']
  end

  def self.iam_roles
    [
      {
        'Effect' => 'Allow',
        'Action' => ['secretsmanager:GetSecretValue'],
        'Recource' => "arn:aws:secretsmanager:#{region}:#{account}:secret:Cloud-template-db-connection-string-*"
      }
    ]
  end

  def self.api_keys
    [
      {
        'name' => prod? ? 'prodKey' : 'devKey'
      }
    ]
  end

  def self.branch_name
    ENV.fetch('BRANCH', 'no-branch')
  end

  def self.region
    ENV.fetch('REGION', 'ap-southeast-2')
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
    ENV.fetch('STAGE', 'local')
  end

  def self.mongo_client
    Mongo::Client.new(mongo_url)
  end

  def self.mongo_url
    ENV.fetch('DB_CONNECTION_STRING', db_connection_string)
  end

  def self.correct_coverage?(hash)
    hash.dig('result', 'line') < 80
  end

  def self.best_coverage?(hash)
    hash.dig('result', 'line') > 95
  end

  def self.db_connection_string
    client = Aws::SecretsManager::Client.new(region: region)

    get_secret_value_response = client.get_secret_value(secret_id: 'Cloud-template-db-connection-string')
    JSON.parse(get_secret_value_response.secret_string)['DB_CONNECTION_STRING']
  end
end
