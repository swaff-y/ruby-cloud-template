# frozen_string_literal: true

require 'yaml'
require 'aws-sdk-secretsmanager'
require_relative '../config'
require_relative '../exceptions/exceptions'

module Tasks
  # base model class
  class Deploy
    def initialize(stage)
      @serverless_yml_hash = YAML.parse(File.read('serverless.yml')).to_ruby
      `rm serverless.yml`
      @stage = stage
    rescue StandardError => e
      Config.logger('error', e.message)
      exit(1)
    end

    def process
      database_url = db_connection_string
      @serverless_yml_hash['service'] = Config.application_serverless
      @serverless_yml_hash['provider']['stage'] = "#{@stage}-#{branch_name}" if @stage == 'dev' && @serverless_yml_hash['provider']
      @serverless_yml_hash['provider']['stage'] = @stage if @stage == 'prod' && @serverless_yml_hash['provider']
      @serverless_yml_hash['custom']['databaseUrl'] = database_url unless database_url.nil? && !@serverless_yml_hash['custom']

      File.write('serverless.yml', @serverless_yml_hash.to_yaml)
    rescue StandardError => e
      Config.logger('error', e.message)
      exit(1)
    end

    private

    def branch_name
      ENV.fetch('BRANCH')
    end

    def db_connection_string
      client = Aws::SecretsManager::Client.new(region: 'ap-southeast-2')

      get_secret_value_response = client.get_secret_value(secret_id: 'Cloud-template-db-connection-string')
      JSON.parse(get_secret_value_response.secret_string)['DB_CONNECTION_STRING']
    end
  end
end
