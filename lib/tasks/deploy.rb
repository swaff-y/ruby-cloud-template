# frozen_string_literal: true

require 'yaml'
require 'aws-sdk-secretsmanager'
require_relative '../config'
require_relative '../exceptions/exceptions'

module Tasks
  # base model class
  class Deploy
    def initialize
      @serverless_yml_hash = YAML.parse(File.read('serverless.yml')).to_ruby
    rescue StandardError => e
      Config.logger('error', "int #{e.message} #{pwd} #{ls}")
      exit(1)
    end

    def process(type)
      database_url = Config.db_connection_string
      @serverless_yml_hash['service'] = Config.application_serverless
      @serverless_yml_hash['provider']['stage'] = "dev-#{Config.branch_name}" if type == 'dev' && @serverless_yml_hash['provider']
      @serverless_yml_hash['provider']['stage'] = 'prod' if type == 'prod' && @serverless_yml_hash['provider']
      @serverless_yml_hash['provider']['region'] = Config.region unless database_url.nil? && !@serverless_yml_hash['custom']
      @serverless_yml_hash['custom']['databaseUrl'] = database_url unless database_url.nil? && !@serverless_yml_hash['custom']

      File.write('serverless.yml', @serverless_yml_hash.to_yaml)
    rescue StandardError => e
      Config.logger('error', "Proc #{e.message}")
      exit(1)
    end
  end
end
