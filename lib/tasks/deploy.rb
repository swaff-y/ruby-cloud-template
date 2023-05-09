# frozen_string_literal: true

require 'yaml'
require 'json'
require 'aws-sdk-secretsmanager'
require_relative '../config'
require_relative '../exceptions/exceptions'

module Tasks
  # base model class
  class Deploy
    def initialize
      @serverless_yml_hash = YAML.parse(File.read('serverless.yml')).to_ruby
      @postman_json_hash = JSON.parse(File.read('postman_collection.json'))
    rescue StandardError => e
      Config.logger('error', "deploy #{e.message}")
      exit(1)
    end

    def process(type)
      process_serverless(type)
      process_postman
    rescue StandardError => e
      Config.logger('error', "Proc #{e.message} #{e.backtrace}")
      exit(1)
    end

    def process_serverless(type)
      database_url = Config.mongo_url
      @serverless_yml_hash['service'] = Config.application_serverless
      @serverless_yml_hash['provider']['stage'] = "dev-#{Config.branch_name}" if type == 'dev' && @serverless_yml_hash['provider']
      @serverless_yml_hash['provider']['stage'] = 'prod' if type == 'prod' && @serverless_yml_hash['provider']
      @serverless_yml_hash['provider']['environment']['STAGE'] = 'dev' if type == 'dev' && @serverless_yml_hash['provider']
      @serverless_yml_hash['provider']['environment']['STAGE'] = 'prod' if type == 'prod' && @serverless_yml_hash['provider']
      @serverless_yml_hash['provider']['region'] = Config.region if @serverless_yml_hash['provider']
      @serverless_yml_hash['provider']['iamRoleStatements'] = Config.iam_roles if @serverless_yml_hash['provider']
      @serverless_yml_hash['custom']['databaseUrl'] = database_url unless database_url.nil? && !@serverless_yml_hash['custom']
      @serverless_yml_hash['custom']['apiKeys'] = Config.api_keys if @serverless_yml_hash['custom']

      File.write('serverless.yml', @serverless_yml_hash.to_yaml)
    end

    def process_postman
      key = ENV.fetch('API_KEY')
      raise StandardError, 'No api key variables set' if key.nil?

      @postman_json_hash.dig('auth', 'apikey').each do |val|
        val['value'] = key if val['key'] == 'value'
      end

      @postman_json_hash['variable'].each do |val|
        val['value'] = Config.prod? ? 'prod' : "dev-#{Config.branch_name}" if val['key'] == 'stage'
      end

      File.write('postman_collection.json', @postman_json_hash.to_json)
    end

    def process_unique_id
      @postman_json_hash['variable'].each do |val|
        val['value'] = ENV.fetch('UNIQUE_ID') if val['key'] == 'unique_id'
      end

      File.write('postman_collection.json', @postman_json_hash.to_json)
    end
  end
end
